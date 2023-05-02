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

    private let viewModel: BreweryDetailViewModel
    private let disposeBag = DisposeBag()
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
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let breweryTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleLarge2)
        label.text = "양조장 이름"
        return label
    }()

    private let breweryGuideLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodyMedium)
        label.text = "방문 가이드 확인하기 >"
        label.textColor = DesignAsset.Colors.gray5.color
        return label
    }()

    private let breweryAddressLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodyMedium)
        label.text = "주소"
        label.textColor = DesignAsset.Colors.gray5.color
        return label
    }()

    private lazy var breweryInfoView: UIView = {
        let infoView = UIView()
        [breweryTitleLabel, breweryGuideLabel, breweryAddressLabel].forEach {
            infoView.addSubview($0)
        }
        breweryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        breweryGuideLabel.snp.makeConstraints {
            $0.top.equalTo(breweryTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        breweryAddressLabel.snp.makeConstraints {
            $0.top.equalTo(breweryGuideLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(10)
        }
        infoView.layer.cornerRadius = 10
        infoView.clipsToBounds = true
        infoView.backgroundColor = .white
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

    init(viewModel: BreweryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpChildViewControllers()
        applyDataSource(tabBars: [
            .products(viewController: productViewController),
            .programs(viewController: programViewController),
            .operationInfo(viewController: operationInfoViewController)
        ])
        layout()
        bind()
    }

    private func setUpTabBarCollectionView() {
        tabBarCollectionView.dataSource = tabBarDataSource
    }

    private func layout() {
        [scrollView, loadingIndicator].forEach { view.addSubview($0) }

        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.insetsLayoutMarginsFromSafeArea = false
        outerStackView.insetsLayoutMarginsFromSafeArea = false
        scrollView.addSubview(outerStackView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.bottom.equalTo(view)
        }
        outerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        [breweryImageView, breweryInfoView, tabBarCollectionView, tabBarContainerView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        breweryImageView.snp.makeConstraints {
            $0.height.equalTo(280)
        }
        tabBarCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1)
        }
        tabBarContainerView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1)
        }

        outerStackView.setCustomSpacing(-10, after: breweryImageView)
    }

    private func bind() {
        tabBarCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.tabBarCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        viewModel.selectedTab
            .asDriver(onErrorJustReturn: (.products(viewController: productViewController)))
            .drive { [weak self] tab in
                guard let self = self else { return }
                var containerViewController: BreweryContainerViewController
                switch tab {
                case let .products(viewController):
                    containerViewController = viewController
                case let .programs(viewController):
                    containerViewController = viewController
                case let .operationInfo(viewController):
                    containerViewController = viewController
                }
                self.tabBarContainerView.subviews.forEach { $0.removeFromSuperview() }
                self.tabBarContainerView.addSubview(containerViewController.view)
                containerViewController.view.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                containerViewController.didMove(toParent: self)
            }
            .disposed(by: disposeBag)

        tabBarCollectionView.rx
            .itemSelected
            .asDriver()
            .drive { [weak self] indexPath in
                if let tab = self?.tabBarDataSource.itemIdentifier(for: indexPath) {
                    self?.viewModel.selectedTab.accept(tab)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setUpChildViewControllers() {
        [productViewController, programViewController, operationInfoViewController].forEach { addChild($0) }
    }
}

// MARK: - TabBar CollectionView Layout

extension BreweryDetailBaseViewController {
    private func tabBarCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(40)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(120), heightDimension: .estimated(40)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - TabBar CollectionView DataSource

extension BreweryDetailBaseViewController {
    enum TabBarCategory: Hashable {
        case products(viewController: BreweryContainerViewController)
        case programs(viewController: BreweryContainerViewController)
        case operationInfo(viewController: BreweryContainerViewController)

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
