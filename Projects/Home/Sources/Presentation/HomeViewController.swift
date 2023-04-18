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
import BaseDomain

public final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let contentScrollView = UIScrollView()
    private let contentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = DesignAsset.gray1.color
        return stackView
    }()

    private lazy var cardNewsDataSource = makeCardNewsDataSource()
    private lazy var cardNewsCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: cardNewsCollectionViewLayout())

    private lazy var viewTop10LiquorDataSource = makeViewTop10DataSource()
    private let viewTop10LiquorTitleBar = TitleBar(title: "방금 보고갔어요 👀", subTitle: "조회수가 높은 상품들")
    private lazy var viewTop10LiquorCollectionView = UICollectionView(frame: .zero,
                                                                      collectionViewLayout: liquorCollectionViewLayout())

    private lazy var keywordListDataSource = makeKeywordDataSource()
    private let keywordListTitleBar = TitleBar(title: "키워드로 찾는 우리술", subTitle: "주류별 키워드")
    private lazy var keywordCollectionView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: keywordCollectionViewLayout())

    private lazy var buyTop10DataSource = makeBuyTop10DataSource()
    private let buyTop10LiquorTitleBar = TitleBar(title: "인기 Top 10 🥇", subTitle: "구매 페이지로 이동이 많은 상품들")
    private lazy var buyTop10LiquorCollectionView = UICollectionView(frame: .zero,
                                                                     collectionViewLayout: liquorCollectionViewLayout())

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpCollectionViews()
        layout()
        HomeSection.allCases.forEach {
            applyDataSource(section: $0)
        }
        bind()
        viewModel.viewDidLoad()
    }

    private func bind() {
        viewModel.applyDataSource = { [weak self] section in
            DispatchQueue.main.async {
                self?.applyDataSource(section: section)
            }
        }
    }

    private func setUpCollectionViews() {
        cardNewsCollectionView.register(CardNewsCell.self, forCellWithReuseIdentifier: CardNewsCell.reuseIdentifier)
        cardNewsCollectionView.dataSource = cardNewsDataSource

        viewTop10LiquorCollectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
        viewTop10LiquorCollectionView.dataSource = viewTop10LiquorDataSource

        keywordCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        keywordCollectionView.dataSource = keywordListDataSource

        buyTop10LiquorCollectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
        buyTop10LiquorCollectionView.dataSource = buyTop10DataSource
    }

    private func layout() {
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentScrollView.addSubview(contentVerticalStackView)
        contentVerticalStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        cardNewsCollectionView.snp.makeConstraints {
            $0.height.equalTo(200)
        }
        viewTop10LiquorCollectionView.snp.makeConstraints {
            $0.height.equalTo(310)
        }
        keywordCollectionView.snp.makeConstraints {
            $0.height.equalTo(180)
        }
        buyTop10LiquorCollectionView.snp.makeConstraints {
            $0.height.equalTo(310)
        }

        [cardNewsCollectionView, viewTop10LiquorTitleBar, viewTop10LiquorCollectionView, keywordListTitleBar, keywordCollectionView, buyTop10LiquorTitleBar, buyTop10LiquorCollectionView].forEach {
            contentVerticalStackView.addArrangedSubview($0)
        }

        [viewTop10LiquorTitleBar, keywordListTitleBar, buyTop10LiquorTitleBar].forEach {
            contentVerticalStackView.setCustomSpacing(0, after: $0)
        }
    }

    private func applyDataSource(section: HomeSection) {
        switch section {
        case .cardNews:
            var cardNewsSnapShot = NSDiffableDataSourceSnapshot<CardNewsSection, String>()
            cardNewsSnapShot.appendSections([.main])
            cardNewsSnapShot.appendItems(["https://thesool.com/common/imageView.do?targetId=D000010000", "https://thesool.com/common/imageView.do?targetId=D000009959"])
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
}

// MARK: - CollectionView

extension HomeViewController {
    private enum CardNewsSection {
        case main
    }

    private func makeCardNewsDataSource() -> UICollectionViewDiffableDataSource<CardNewsSection, String> {
        return .init(collectionView: cardNewsCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardNewsCell.reuseIdentifier, for: indexPath) as? CardNewsCell else { return UICollectionViewCell() }
            cell.setUpImage(imagePath: itemIdentifier)
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
            cell.setUpContents(keyword: keyword, imagePath: keyword.imagePath)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(10), trailing: .fixed(0), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 11, bottom: 8, trailing: 11)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
