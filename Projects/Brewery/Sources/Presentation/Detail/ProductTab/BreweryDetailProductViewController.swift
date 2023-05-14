//
//  BreweryDetailProductViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BreweryDomain

final class BreweryDetailProductViewController: BreweryContainerViewController {

    private let viewModel: BreweryDetailViewModel
    private var disposeBag = DisposeBag()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        return stackView
    }()

    private lazy var categoryCollectionView = SizableCollectionView(
        frame: .zero,
        collectionViewLayout: categoryCollectionViewLayout()
    )
    private lazy var categoryDataSource = makeCategoryDataSource()

    private let productCountLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodyMedium)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()

    private lazy var productCollectionView = SizableCollectionView(
        frame: .zero,
        collectionViewLayout: productCollectionViewLayout()
    )
    private lazy var productDataSource = makeProductDataSource()

    init(viewModel: BreweryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
        layout()
        bind()
    }

    private func setUpCollectionViews() {
        categoryCollectionView.dataSource = categoryDataSource
        productCollectionView.dataSource = productDataSource
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        [categoryCollectionView, productCollectionView].forEach { $0.isScrollEnabled = false }
    }

    private func layout() {
        sizableView.addSubview(outerStackView)
        outerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        [categoryCollectionView, productCollectionView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        [categoryCollectionView, productCollectionView].forEach { collectionView in
            collectionView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(1)
            }
        }
    }

    private func bind() {
        [categoryCollectionView, productCollectionView].forEach { collectionView in
            collectionView.contentSizeDidChanged
                .asSignal()
                .emit { size in
                    if size.height > 0 {
                        collectionView.snp.remakeConstraints {
                            $0.height.equalTo(size.height)
                        }
                    }
                }
                .disposed(by: disposeBag)
        }

        viewModel.brewery.asDriver()
            .map { $0.products }
            .drive { [weak self] products in
                guard let self = self else { return }
                self.applyDataSource(section: .product(products))
                self.applyDataSource(section: .category(self.viewModel.productCategories))
            }
            .disposed(by: disposeBag)

        productCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] indexPath in
                if let item = self?.productDataSource.itemIdentifier(for: indexPath) {
                    self?.coordinator?.liquorTapped(liquorName: item.name)
                }
            }
            .disposed(by: disposeBag)

        categoryCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] indexPath in
                guard let self = self,
                      let selectedType = self.categoryDataSource.itemIdentifier(for: indexPath) else { return }
                self.applyDataSource(
                    section: .product(
                        self.viewModel.brewery.value.products.filter { $0.liquorType == selectedType }
                    )
                )
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - CollectionView Layout

extension BreweryDetailProductViewController {
    private func categoryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(100),
                                                            heightDimension: .estimated(40)))
        item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .estimated(100),
                              heightDimension: .estimated(40)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 14, leading: 0, bottom: 0, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func productCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .estimated(113)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(113)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension BreweryDetailProductViewController {
    enum CategorySection {
        case main
    }

    private func makeCategoryDataSource() -> UICollectionViewDiffableDataSource<CategorySection, LiquorType> {
        return .init(collectionView: categoryCollectionView) { collectionView, indexPath, category in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            cell.setUpContents(category: category)
            return cell
        }
    }

    enum ProductSection {
        case main
    }

    private func makeProductDataSource() -> UICollectionViewDiffableDataSource<ProductSection, LiquorOverview> {
        return .init(collectionView: productCollectionView) { collectionView, indexPath, liquor in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            cell.setUpContents(liquor: liquor)
            return cell
        }
    }

    enum Section: CaseIterable {
        static var allCases: [Section] = [.category([]), .product([])]

        case category([LiquorType])
        case product([LiquorOverview])
    }

    private func applyDataSource(section: Section) {
        switch section {
        case .category(let categories):
            var categorySnapShot = NSDiffableDataSourceSnapshot<CategorySection, LiquorType>()
            categorySnapShot.deleteAllItems()
            categorySnapShot.appendSections([.main])
            categorySnapShot.appendItems(categories)
            categoryDataSource.apply(categorySnapShot)
        case .product(let products):
            var productSnapShot = NSDiffableDataSourceSnapshot<ProductSection, LiquorOverview>()
            productSnapShot.deleteAllItems()
            productSnapShot.appendSections([.main])
            productSnapShot.appendItems(products)
            productDataSource.apply(productSnapShot)
        }
    }
}
