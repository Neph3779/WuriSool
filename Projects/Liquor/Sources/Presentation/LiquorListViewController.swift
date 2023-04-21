//
//  ViewController.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import SnapKit
import LiquorDomain

final class LiquorListViewController: UIViewController {

    private let viewModel: LiquorListViewModel

    private let scrollView = UIScrollView()

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = DesignAsset.gray1.color
        return stackView
    }()

    private lazy var keywordCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: keywordCollectionViewLayout())
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        return collectionView
    }()
    private lazy var keywordDataSource = makeKeywordDataSource()

    private let productCountLabel: UILabel = {
        let label = UILabel()
        label.text = "판매상품 0개"
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.gray4.color
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.gray4.color
        label.text = "카테고리 ▽"
        return label
    }()

    private lazy var infoView: UIView = {
        let infoView = UIView()
        [productCountLabel, categoryLabel].forEach {
            infoView.addSubview($0)
        }
        productCountLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(15)
        }
        categoryLabel.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview().inset(15)
        }

        infoView.backgroundColor = .white
        return infoView
    }()

    private lazy var liquorCollectionView: LiquorListCollectionView = {
        let collectionView = LiquorListCollectionView(frame: .zero, collectionViewLayout: liquorCollectionViewLayout())
        collectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    private lazy var liquorDataSource = makeLiquorDataSource()

    init(viewModel: LiquorListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpScrollView()
        setUpCollectionViews()
        bind()
        layout()
        LiquorListSection.allCases.forEach {
            applyDataSource(section: $0)
        }
        viewModel.viewDidLoad()
    }

    private func setUpScrollView() {
        scrollView.delegate = self
    }

    private func setUpCollectionViews() {
        keywordCollectionView.dataSource = keywordDataSource
        liquorCollectionView.dataSource = liquorDataSource
    }

    private func bind() {
        liquorCollectionView.contentSizeDidChanged = { [weak self] size in
            if size.height > 0 {
                self?.liquorCollectionView.snp.remakeConstraints {
                    $0.height.equalTo(size.height)
                }
            }
        }

        viewModel.applyDataSource = { [weak self] section in
            DispatchQueue.main.async {
                self?.applyDataSource(section: section)
            }
        }

        viewModel.updateLiquorCount = { [weak self] liquorCount in
            DispatchQueue.main.async {
                self?.productCountLabel.text = "판매상품 \(liquorCount)개"
            }
        }
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(outerStackView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        outerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        [keywordCollectionView, infoView, liquorCollectionView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        keywordCollectionView.snp.makeConstraints {
            $0.height.equalTo(95)
        }
        liquorCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1) // trigger for estimate collectionView's size
        }
    }
}

// MARK: - CollectionView Layout

extension LiquorListViewController {
    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(95)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(95)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func liquorCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(250)))
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [item])
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)), subitems: [horizontalGroup])
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension LiquorListViewController {
    enum KeywordSection {
        case main
    }

    private func makeKeywordDataSource() -> UICollectionViewDiffableDataSource<KeywordSection, Keyword> {
        return .init(collectionView: keywordCollectionView) { collectionView, indexPath, keyword in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifier, for: indexPath) as? KeywordCell else { return UICollectionViewCell() }
            cell.setUpContents(keyword: keyword)
            return cell
        }
    }

    enum LiquorSection {
        case main
    }

    private func makeLiquorDataSource() -> UICollectionViewDiffableDataSource<LiquorSection, Liquor> {
        return .init(collectionView: liquorCollectionView) { collectionView, indexPath, liquor in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiquorCell.reuseIdentifier, for: indexPath) as? LiquorCell else { return UICollectionViewCell() }
            cell.setUpContents(liquor: liquor)
            return cell
        }
    }

    enum LiquorListSection: CaseIterable {
        static var allCases: [LiquorListViewController.LiquorListSection] = [.keywords([]), .liquors([])]

        case keywords([Keyword])
        case liquors([Liquor])
    }

    private func applyDataSource(section: LiquorListSection) {
        switch section {
        case .keywords(let keywords):
            var keywordsSnapShot = NSDiffableDataSourceSnapshot<KeywordSection, Keyword>()
            keywordsSnapShot.deleteAllItems()
            keywordsSnapShot.appendSections([.main])
            keywordsSnapShot.appendItems(Keyword.allCases) // keywords로 교체
            keywordDataSource.apply(keywordsSnapShot)
        case .liquors(let liquors):
            var liquorsSnapShot = NSDiffableDataSourceSnapshot<LiquorSection, Liquor>()
            liquorsSnapShot.deleteAllItems()
            liquorsSnapShot.appendSections([.main])
            liquorsSnapShot.appendItems(liquors) // liquors로 교체
            liquorDataSource.apply(liquorsSnapShot)
        }
    }
}

// MARK: - CollectionView Delegate

extension LiquorListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > scrollView.contentSize.height - view.frame.height {
            print("over")
            // load next data
            viewModel.fetchLiquors()
        }
    }
}
