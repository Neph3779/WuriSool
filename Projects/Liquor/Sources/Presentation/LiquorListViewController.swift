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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = DesignAsset.gray1.color
        return stackView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        return searchBar
    }()

    private lazy var keywordCollectionView: LiquorListCollectionView = {
        let collectionView = LiquorListCollectionView(frame: .zero, collectionViewLayout: keywordCollectionViewLayout())
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
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

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.gray4.color
        label.text = "카테고리 ▽"
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(categoryCellTapped(_:))
        ))
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
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 34, right: 0)
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var liquorDataSource = makeLiquorDataSource()

    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = DesignAsset.gray1.color.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()

    private lazy var categoryModalView: UIView = {
        let categoryView = UIView()
        categoryView.backgroundColor = .black.withAlphaComponent(0.3)
        categoryView.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        categoryView.isHidden = true
        categoryView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(modalBackgroundTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        categoryView.addGestureRecognizer(tapGesture)
        return categoryView
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
        keywordCollectionView.contentSizeDidChanged = { [weak self] size in
            if size.height > 0 {
                self?.keywordCollectionView.snp.remakeConstraints {
                    $0.height.equalTo(size.height)
                }
            }
        }
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
        view.addSubview(categoryModalView)
        categoryModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        [searchBar, keywordCollectionView, infoView, liquorCollectionView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        keywordCollectionView.snp.makeConstraints {
            $0.height.equalTo(95)
        }
        liquorCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1) // trigger for estimate collectionView's size
        }
        outerStackView.setCustomSpacing(0, after: searchBar)
    }

    @objc
    private func categoryCellTapped(_ sender: UITapGestureRecognizer) {
        categoryModalView.isHidden = false
    }

    @objc
    private func modalBackgroundTapped(_ sender: UITapGestureRecognizer) {
        categoryModalView.isHidden = true
    }
}

// MARK: - CollectionView Layout

extension LiquorListViewController {
    private func keywordCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(95)))
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
            keywordsSnapShot.appendItems(keywords)
            keywordDataSource.apply(keywordsSnapShot)
        case .liquors(let liquors):
            var liquorsSnapShot = NSDiffableDataSourceSnapshot<LiquorSection, Liquor>()
            liquorsSnapShot.deleteAllItems()
            liquorsSnapShot.appendSections([.main])
            liquorsSnapShot.appendItems(liquors)
            liquorDataSource.apply(liquorsSnapShot)
        }
    }
}

// MARK: - CollectionView Delegate

extension LiquorListViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != categoryTableView,
           scrollView.contentOffset.y > scrollView.contentSize.height - view.frame.height
            && !viewModel.isUpdating {
            viewModel.fetchLiquors()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == keywordCollectionView {
            viewModel.keywordDidTapped(indexPath: indexPath)
        } else {

        }
    }
}

extension LiquorListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LiquorType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = LiquorType.allCases[indexPath.row].name
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liquorType = LiquorType.allCases[indexPath.row]
        categoryModalView.isHidden = true
        categoryLabel.text = liquorType.name
        categoryLabel.font = .boldSystemFont(ofSize: 14)
        viewModel.selectedType = liquorType
    }
}

extension LiquorListViewController: UISearchBarDelegate {

}
