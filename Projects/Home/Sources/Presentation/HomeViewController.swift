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
    private let contentVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var cardNewsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cardNewsCollectionViewLayout())
        return collectionView
    }()

    private let viewTop10LiquorTitleBar = TitleBar(title: "", subTitle: "")
    private let viewTop10LiquorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private let keywordListTitleBar = TitleBar(title: "", subTitle: "")
    private lazy var keywordCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: keywordCollectionViewLayout())
        return collectionView
    }()

    private let buyTop10LiquorTitleBar = TitleBar(title: "", subTitle: "")
    private let buyTop10LiquorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

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
    }

    private func layout() {

    }

    private enum CardNewsSection {
        case main
    }

    private func cardNewsDataSource() -> UICollectionViewDiffableDataSource<CardNewsSection, String> {
        return .init(collectionView: cardNewsCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardNewsCell.reuseIdentifier, for: indexPath)
            return cell
        }
    }

    private enum KeywordSection {
        case main
    }

    private func cardNewsDataSource() -> UICollectionViewDiffableDataSource<KeywordSection, String> {
        return .init(collectionView: cardNewsCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifier, for: indexPath)
            return cell
        }
    }

    private func cardNewsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = .init(leading: .fixed(5), top: .fixed(5), trailing: .fixed(5), bottom: .fixed(5))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
