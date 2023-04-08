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

public final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private let contentScrollView = UIScrollView()
    private let contentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
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
        applyDataSource()
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
            $0.height.equalTo(270)
        }
        keywordCollectionView.snp.makeConstraints {
            $0.height.equalTo(168)
        }
        buyTop10LiquorCollectionView.snp.makeConstraints {
            $0.height.equalTo(270)
        }

        [cardNewsCollectionView, viewTop10LiquorTitleBar, viewTop10LiquorCollectionView, keywordListTitleBar, keywordCollectionView, buyTop10LiquorTitleBar, buyTop10LiquorCollectionView].forEach {
            contentVerticalStackView.addArrangedSubview($0)
        }
    }

    private func applyDataSource() {
        var cardNewsSnapShot = NSDiffableDataSourceSnapshot<CardNewsSection, String>()
        cardNewsSnapShot.appendSections([.main])
        cardNewsSnapShot.appendItems(["https://thesool.com/common/imageView.do?targetId=PR00000508&targetNm=PRODUCT", "2"], toSection: .main)
        cardNewsDataSource.apply(cardNewsSnapShot)

        var viewTop10SnapShot = NSDiffableDataSourceSnapshot<ViewTop10Section, Liquor>()
        viewTop10SnapShot.appendSections([.main])
        viewTop10SnapShot.appendItems([.init(data: [:])])
        self.viewTop10LiquorDataSource.apply(viewTop10SnapShot)

        var keywordSnapShot = NSDiffableDataSourceSnapshot<KeywordSection, String>()
        keywordSnapShot.appendSections([.main])
        keywordSnapShot.appendItems(["dummy", ""], toSection: .main)
        keywordListDataSource.apply(keywordSnapShot)

        var buyTop10SnapShot = NSDiffableDataSourceSnapshot<BuyTop10Section, Liquor>()
        buyTop10SnapShot.appendSections([.main])
        buyTop10SnapShot.appendItems([Liquor(data: [:])], toSection: .main)
        buyTop10DataSource.apply(buyTop10SnapShot)
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

    private func makeKeywordDataSource() -> UICollectionViewDiffableDataSource<KeywordSection, String> {
        return .init(collectionView: keywordCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifier, for: indexPath) as? KeywordCell else { return UICollectionViewCell() }
            cell.setUpContents(keyword: .berry, imagePath: itemIdentifier)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = .init(leading: .fixed(5), top: .fixed(5), trailing: .fixed(5), bottom: .fixed(5))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 11, bottom: 0, trailing: 11)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
