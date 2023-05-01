//
//  BreweryDetailViewController.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/01.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BreweryDetailBaseViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()

    private let breweryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let breweryTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let breweryGuideLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let breweryAddressLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var breweryInfoView: UIView = {
        let infoView = UIView()
        [breweryTitleLabel, breweryGuideLabel, breweryAddressLabel].forEach {
            infoView.addSubview($0)
        }
        breweryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        breweryGuideLabel.snp.makeConstraints {
            $0.top.equalTo(breweryTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        breweryAddressLabel.snp.makeConstraints {
            $0.top.equalTo(breweryGuideLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(4)
        }
        return infoView
    }()

    private lazy var tabBarCollectionView: SizableCollectionView = {
        let collectionView = SizableCollectionView(frame: .zero, collectionViewLayout: tabBarCollectionViewLayout())
        collectionView.register(BreweryCategoryCell.self, forCellWithReuseIdentifier: BreweryCategoryCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private lazy var tabBarDataSource = makeTabBarDataSource()

    private let tabBarContainerView = UIView()
    private let productViewController = BreweryDetailProductViewController()
    private let programViewController = BreweryDetailProgramViewController()
    private let operationInfoViewController = BreweryDetailOperationInfoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpChildViewControllers()
        applyDataSource(tabBars: TabBarCategory.allCases)
    }

    private func setUpTabBarCollectionView() {
        tabBarCollectionView.dataSource = tabBarDataSource
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
        [breweryImageView, breweryInfoView, tabBarCollectionView, tabBarContainerView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        breweryImageView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
    }

    private func bind() {
        // selected tab 바뀌면 기존것 removeFromSuperView하고 뷰 추가
        /*
         tabBarContainerView.addSubview(productViewController.view)
         productViewController.view.snp.makeConstraints {
             $0.edges.equalToSuperview()
         }
         productViewController.didMove(toParent: self)
         */
    }

    private func setUpChildViewControllers() {
        [productViewController, programViewController, operationInfoViewController].forEach { addChild($0) }
    }
}

// MARK: - TabBar CollectionView Layout

extension BreweryDetailBaseViewController {
    private func tabBarCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - TabBar CollectionView DataSource

extension BreweryDetailBaseViewController {
    enum TabBarCategory: Hashable, CaseIterable {
        case products
        case programs
        case operationInfo

        var name: String {
            switch self {
            case .products:
                return "판매상품"
            case .programs:
                return "체험 프로그램"
            case .operationInfo:
                return "운영정보"
            }
        }
    }
    enum TabBarSection {
        case main
    }

    private func makeTabBarDataSource() -> UICollectionViewDiffableDataSource<TabBarSection, TabBarCategory> {
        return .init(collectionView: tabBarCollectionView) { collectionView, indexPath, category in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreweryCategoryCell.reuseIdentifier, for: indexPath) as? BreweryCategoryCell else { return UICollectionViewCell() }
            cell.setUpContents(title: category.name)
            return cell
        }
    }

    private func applyDataSource(tabBars: [TabBarCategory]) {
        var tabBarSnapShot = NSDiffableDataSourceSnapshot<TabBarSection, TabBarCategory>()
        tabBarSnapShot.deleteAllItems()
        tabBarSnapShot.appendSections([.main])
        tabBarSnapShot.appendItems(tabBars)
        tabBarDataSource.apply(tabBarSnapShot)
    }
}
