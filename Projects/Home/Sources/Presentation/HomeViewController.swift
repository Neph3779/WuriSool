//
//  HomeViewController.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import HomeDomain
import SnapKit
import Design
import RxSwift
import RxCocoa

public final class HomeViewController: UIViewController {

    var coordinator: HomeCoordinatorInterface?
    private var disposeBag = DisposeBag()
    private let viewModel: HomeViewModel

    private let contentScrollView = UIScrollView()
    private let contentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        return stackView
    }()

    private let logoTitleBar: UIView = {
        let titleBar = UIView()
        let logoImageView = UIImageView(image: DesignAsset.Images.logo.image)
        titleBar.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        logoImageView.setContentHuggingPriority(.required, for: .horizontal)
        logoImageView.contentMode = .scaleAspectFit
        titleBar.backgroundColor = .white
        return titleBar
    }()

    private lazy var cardNewsDataSource = makeCardNewsDataSource()
    private lazy var cardNewsCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: cardNewsCollectionViewLayout())

    private lazy var viewTop10LiquorDataSource = makeViewTop10DataSource()
    private let viewTop10LiquorTitleBar = TitleBar(title: "View Top", subTitle: "조회수가 높은 상품")
    private lazy var viewTop10LiquorCollectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: liquorCollectionViewLayout())

    private lazy var recommendImageView: UIImageView = {
        let imageView = UIImageView(image: DesignAsset.Images.recommendImage.image)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(recommendImageViewTapped(_:))))
        return imageView
    }()

    private lazy var keywordListDataSource = makeKeywordDataSource()
    private let keywordListTitleBar = TitleBar(title: "Keyword", subTitle: "주류별 키워드")
    private lazy var keywordCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: keywordCollectionViewLayout())

    private lazy var buyTop10DataSource = makeBuyTop10DataSource()
    private let buyTop10LiquorTitleBar = TitleBar(title: "Most Popular", subTitle: "구매 이동이 많은 상품")
    private lazy var buyTop10LiquorCollectionView = UICollectionView(frame: .zero,
                                                                     collectionViewLayout: liquorCollectionViewLayout())

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .minimal
        setUpCollectionViews()
        layout()
        HomeSection.allCases.forEach {
            applyDataSource(section: $0)
        }
        bind()
        viewModel.viewDidLoad()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    private func bind() {
        viewModel.applyDataSource = { [weak self] section in
            DispatchQueue.main.async {
                self?.applyDataSource(section: section)
            }
        }
        cardNewsCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] (indexPath: IndexPath) in
                guard let self = self,
                      let cardNews = self.cardNewsDataSource.itemIdentifier(for: indexPath) else {
                    return
                }
                if let url = URL(string: cardNews.link),
                          UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
        viewTop10LiquorCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] (indexPath: IndexPath) in
                self?.coordinator?.liquorTapped(liquorName: self?.viewModel.viewTop10Liquors[indexPath.row].name ?? "")
            }
            .disposed(by: disposeBag)
        buyTop10LiquorCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] (indexPath: IndexPath) in
                self?.coordinator?.liquorTapped(liquorName: self?.viewModel.buyTop10Liquors[indexPath.row].name ?? "")
            }
            .disposed(by: disposeBag)
        keywordCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] (indexPath: IndexPath) in
                let keyword = self?.keywordListDataSource.itemIdentifier(for: indexPath)
                self?.coordinator?.keywordTapped(keyword: keyword ?? .others)
            }
            .disposed(by: disposeBag)
    }

    private func setUpCollectionViews() {
        cardNewsCollectionView.register(CardNewsCell.self, forCellWithReuseIdentifier: CardNewsCell.reuseIdentifier)
        cardNewsCollectionView.dataSource = cardNewsDataSource

        viewTop10LiquorCollectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
        viewTop10LiquorCollectionView.dataSource = viewTop10LiquorDataSource

        keywordCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        keywordCollectionView.dataSource = keywordListDataSource
        keywordCollectionView.isScrollEnabled = false

        buyTop10LiquorCollectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
        buyTop10LiquorCollectionView.dataSource = buyTop10DataSource
    }

    private func layout() {
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        contentScrollView.addSubview(contentVerticalStackView)
        contentVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        cardNewsCollectionView.snp.makeConstraints {
            $0.height.equalTo(cardNewsCollectionView.snp.width)
        }
        viewTop10LiquorCollectionView.snp.makeConstraints {
            $0.height.equalTo(310)
        }
        recommendImageView.snp.makeConstraints {
            $0.height.equalTo(recommendImageView.snp.width)
        }
        keywordCollectionView.snp.makeConstraints {
            $0.height.equalTo(180)
        }
        buyTop10LiquorCollectionView.snp.makeConstraints {
            $0.height.equalTo(310)
        }

        [
            logoTitleBar,
            cardNewsCollectionView,
            keywordListTitleBar, keywordCollectionView,
            viewTop10LiquorTitleBar, viewTop10LiquorCollectionView,
            recommendImageView,
            buyTop10LiquorTitleBar, buyTop10LiquorCollectionView
        ].forEach {
            contentVerticalStackView.addArrangedSubview($0)
        }

        [keywordCollectionView, viewTop10LiquorCollectionView].forEach {
            contentVerticalStackView.setCustomSpacing(1, after: $0)
        }
    }

    private func applyDataSource(section: HomeSection) {
        switch section {
        case .cardNews:
            var cardNewsSnapShot = NSDiffableDataSourceSnapshot<CardNewsSection, CardNews>()
            cardNewsSnapShot.appendSections([.main])
            cardNewsSnapShot.appendItems([
                .init(data: [
                    "id": 2780,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/[AT]-%EB%8D%94%EC%88%A0%EB%8B%B7%EC%BB%B4-%EC%9D%B8%EC%8A%A4%ED%83%80%EA%B7%B8%EB%9E%A8-%EC%B9%B4%EB%93%9C%EB%89%B4%EC%8A%A4-%EB%94%94%EC%9E%90%EC%9D%B81_20230606_1686705111791.jpg"
                ]),
                .init(data: [
                    "id": 2776,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/[AT]-%EB%8D%94%EC%88%A0%EB%8B%B7%EC%BB%B4-%EC%9D%B8%EC%8A%A4%ED%83%80%EA%B7%B8%EB%9E%A8-%EC%B9%B4%EB%93%9C%EB%89%B4%EC%8A%A4-%EB%94%94%EC%9E%90%EC%9D%B81_20230531_1686716949154.jpg"
                ]),
                .init(data: [
                    "id": 2773,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/[at]-%EB%8D%94%EC%88%A0%EB%8B%B7%EC%BB%B4-5%EC%9B%94-4_1686717164110.jpg"
                ]),
                .init(data: [
                    "id": 2766,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/[at]-5%EC%9B%94-4%EC%A3%BC%EC%B0%A8-%EC%BD%98%ED%85%90%EC%B8%A0(1)-%EB%94%94%EC%9E%90%EC%9D%B8_20230516_1686717376233.jpg"
                ]),
                .init(data: [
                    "id": 2763,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/[AT]-%EB%8D%94%EC%88%A0%EB%8B%B7%EC%BB%B4-%EC%9D%B8%EC%8A%A4%ED%83%80%EA%B7%B8%EB%9E%A8-%EC%B9%B4%EB%93%9C%EB%89%B4%EC%8A%A4-%EB%94%94%EC%9E%90%EC%9D%B81_20230516_1684306080018.jpg"
                ]),
                .init(data: [
                    "id": 2759,
                    "imagePath": "https://thesool.com/ckeditor/imageUpload/%EC%9D%B8%EC%8A%A4%ED%83%80%EA%B7%B8%EB%9E%A8-%EC%B9%B4%EB%93%9C%EB%89%B4%EC%8A%A4-%ED%95%98%EB%8B%A8%EC%82%BD%EC%9E%851_20230503_1683094785172.jpg"
                ])
            ])
            cardNewsDataSource.apply(cardNewsSnapShot)
        case .viewTop10(let liquors):
            var viewTop10SnapShot = NSDiffableDataSourceSnapshot<ViewTop10Section, Liquor>()
            viewTop10SnapShot.appendSections([.main])
            viewTop10SnapShot.appendItems(liquors)
            self.viewTop10LiquorDataSource.apply(viewTop10SnapShot)
        case .keyword(let keywords):
            var keywordSnapShot = NSDiffableDataSourceSnapshot<KeywordSection, Keyword>()
            keywordSnapShot.appendSections([.main])
            keywordSnapShot.appendItems(keywords.map { $0 })
            keywordListDataSource.apply(keywordSnapShot)
        case .buyTop10(let liquors):
            var buyTop10SnapShot = NSDiffableDataSourceSnapshot<BuyTop10Section, Liquor>()
            buyTop10SnapShot.appendSections([.main])
            buyTop10SnapShot.appendItems(liquors)
            buyTop10DataSource.apply(buyTop10SnapShot)
        }
    }

    enum HomeSection: CaseIterable {
        static var allCases: [HomeViewController.HomeSection] = [.cardNews, .viewTop10([]), .keyword([]), .buyTop10([])]

        case cardNews
        case viewTop10([Liquor])
        case keyword([Keyword])
        case buyTop10([Liquor])
    }

    @objc
    private func recommendImageViewTapped(_ sender: UIGestureRecognizer) {
        coordinator?.recommendImageViewTapped()
    }
}

// MARK: - CollectionView

extension HomeViewController {
    private enum CardNewsSection {
        case main
    }

    private func makeCardNewsDataSource() -> UICollectionViewDiffableDataSource<CardNewsSection, CardNews> {
        return .init(collectionView: cardNewsCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardNewsCell.reuseIdentifier, for: indexPath) as? CardNewsCell else { return UICollectionViewCell() }
            cell.setUpImage(imagePath: itemIdentifier.imagePath)
            return cell
        }
    }

    private enum ViewTop10Section {
        case main
    }

    private func makeViewTop10DataSource() -> UICollectionViewDiffableDataSource<ViewTop10Section, Liquor> {
        return .init(collectionView: viewTop10LiquorCollectionView) { collectionView, indexPath, liquor in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiquorCell.reuseIdentifier, for: indexPath) as? LiquorCell else { return UICollectionViewCell() }
            cell.setUpContents(liquor: liquor)
            return cell
        }
    }

    private enum KeywordSection {
        case main
    }

    private func makeKeywordDataSource() -> UICollectionViewDiffableDataSource<KeywordSection, Keyword> {
        return .init(collectionView: keywordCollectionView) { collectionView, indexPath, keyword in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifier, for: indexPath) as? KeywordCell else { return UICollectionViewCell() }
            cell.setUpContents(keyword: keyword)
            return cell
        }
    }

    private enum BuyTop10Section {
        case main
    }

    private func makeBuyTop10DataSource() -> UICollectionViewDiffableDataSource<BuyTop10Section, Liquor> {
        return .init(collectionView: buyTop10LiquorCollectionView) { collectionView, indexPath, liquor in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiquorCell.reuseIdentifier, for: indexPath) as? LiquorCell else { return UICollectionViewCell() }
            cell.setUpContents(liquor: liquor)
            return cell
        }
    }

    private func cardNewsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func liquorCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(10), top: .fixed(0), trailing: .fixed(10), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 6, bottom: 16, trailing: 16)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/6), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [horizontalGroup])
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = .init(top: 8, leading: 11, bottom: 8, trailing: 11)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
