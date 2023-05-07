//
//  BreweryListViewController.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import RxSwift
import RxCocoa
import SnapKit

final class BreweryListViewController: UIViewController {
    var coordinator: BreweryCoordinatorInterface?
    private let viewModel: BreweryListViewModel
    private var disposeBag = DisposeBag()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()

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

    private lazy var addressCollectionView: SizableCollectionView = {
        let collectionView = SizableCollectionView(frame: .zero, collectionViewLayout: addressCollectionViewLayout())
        collectionView.register(BreweryCategoryCell.self, forCellWithReuseIdentifier: BreweryCategoryCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private lazy var addressDataSource = makeAddressDataSource()

    private lazy var breweryCollectionView: SizableCollectionView = {
        let collectionView = SizableCollectionView(frame: .zero, collectionViewLayout: breweryCollectionViewLayout())
        collectionView.register(BreweryListCell.self, forCellWithReuseIdentifier: BreweryListCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 34, right: 0)
        return collectionView
    }()

    private lazy var breweryDataSource = makeBreweryDataSource()

    init(viewModel: BreweryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
        setUpCollectionViews()
        bind()
        layout()
        applyDataSource(section: .address(Region.allCases.map { $0.name }))
        addressCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }

    private func setUpCollectionViews() {
        addressCollectionView.dataSource = addressDataSource
        breweryCollectionView.dataSource = breweryDataSource
    }

    private func bind() {
        viewModel.brewerys
            .asDriver()
            .drive { [weak self] brewerys in
                self?.applyDataSource(section: .brewery(brewerys))
            }
            .disposed(by: disposeBag)
        addressCollectionView.rx.itemSelected
            .asDriver()
            .drive { [weak self] indexPath in
                if let address = self?.addressDataSource.itemIdentifier(for: indexPath) {
                    self?.viewModel.selectedRegion.accept(address)
                }
            }
            .disposed(by: disposeBag)
        addressCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.addressCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        breweryCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.breweryCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        breweryCollectionView.rx.itemSelected
            .asDriver()
            .drive { [weak self] (indexPath: IndexPath) in
                guard let self = self else { return }
                let item = self.viewModel.brewerys.value[indexPath.row]
                self.coordinator?.listCellSelected(breweryName: item.name)
            }
            .disposed(by: disposeBag)
    }

    private func layout() {
        [scrollView, loadingIndicator].forEach { view.addSubview($0) }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        scrollView.addSubview(outerStackView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        outerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        [addressCollectionView, breweryCollectionView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        addressCollectionView.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        breweryCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1) // trigger for estimate collectionView's size
        }
    }
}

// MARK: - CollectionView Layout

extension BreweryListViewController {
    private func addressCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func breweryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(298)))
        item.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(298)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension BreweryListViewController {
    enum AddressSeciton {
        case main
    }

    private func makeAddressDataSource() -> UICollectionViewDiffableDataSource<AddressSeciton, String> {
        return .init(collectionView: addressCollectionView) { collectionView, indexPath, address in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreweryCategoryCell.reuseIdentifier, for: indexPath) as? BreweryCategoryCell else { return UICollectionViewCell() }
            cell.setUpContents(title: address)
            return cell
        }
    }

    enum BrewerySection {
        case main
    }

    private func makeBreweryDataSource() -> UICollectionViewDiffableDataSource<BrewerySection, Brewery> {
        return .init(collectionView: breweryCollectionView) { collectionView, indexPath, brewery in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreweryListCell.reuseIdentifier, for: indexPath) as? BreweryListCell else { return UICollectionViewCell() }
            cell.setUpContents(brewery: brewery)
            return cell
        }
    }

    enum BreweryListSection: CaseIterable {
        static var allCases: [BreweryListViewController.BreweryListSection] = [.address([]), .brewery([])]

        case address([String])
        case brewery([Brewery])
    }

    private func applyDataSource(section: BreweryListSection) {
        switch section {
        case .address(let address):
            var addressSnapShot = NSDiffableDataSourceSnapshot<AddressSeciton, String>()
            addressSnapShot.deleteAllItems()
            addressSnapShot.appendSections([.main])
            addressSnapShot.appendItems(address)
            addressDataSource.apply(addressSnapShot)
        case .brewery(let brewery):
            var brewerySnapShot = NSDiffableDataSourceSnapshot<BrewerySection, Brewery>()
            brewerySnapShot.deleteAllItems()
            brewerySnapShot.appendSections([.main])
            brewerySnapShot.appendItems(brewery)
            breweryDataSource.apply(brewerySnapShot)
        }
    }
}

public extension Reactive where Base: UIScrollView {
    /**
     Shows if the bottom of the UIScrollView is reached.
     - parameter offset: A threshhold indicating the bottom of the UIScrollView.
     - returns: ControlEvent that emits when the bottom of the base UIScrollView is reached.
     */
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { [base] contentOffset in
            let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
            let y = contentOffset.y + base.contentInset.top
            let threshold = max(offset, base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}
