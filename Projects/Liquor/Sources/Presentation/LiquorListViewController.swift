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

    private lazy var keywordCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: keywordCollectionViewLayout())
        return collectionView
    }()

    private lazy var liquorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: liquorCollectionViewLayout())
        return collectionView
    }()
    init(viewModel: LiquorListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CollectionView Layout

extension LiquorListViewController {
    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func liquorCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/4)), subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension LiquorListViewController {
    enum KeywordSection {
        case main
    }

    private func keywordDataSource() -> UICollectionViewDiffableDataSource<KeywordSection, Keyword> {
        return .init(collectionView: keywordCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.reuseIdentifier, for: indexPath) as? KeywordCell else { return UICollectionViewCell() }
            return cell
        }
    }

    enum LiquorSection {
        case main
    }

    private func liquorDataSource() -> UICollectionViewDiffableDataSource<LiquorSection, Liquor> {
        return .init(collectionView: liquorCollectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiquorCell.reuseIdentifier, for: indexPath) as? LiquorCell else { return UICollectionViewCell() }
            return cell
        }
    }
}
