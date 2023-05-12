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
import RxSwift
import RxCocoa

public final class LiquorListViewController: UIViewController {

    public var coordinator: (any LiquorCoordinatorInterface)?
    private let viewModel: LiquorListViewModel
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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.placeholder = "주류를 검색해보세요"
        return searchBar
    }()

    private lazy var keywordCollectionView: LiquorListCollectionView = {
        let collectionView = LiquorListCollectionView(frame: .zero, collectionViewLayout: keywordCollectionViewLayout())
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private lazy var keywordDataSource = makeKeywordDataSource()

    private let productCountLabel: UILabel = {
        let label = UILabel()
        label.text = "판매상품 0개"
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.Colors.gray4.color
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
        return collectionView
    }()

    private lazy var liquorDataSource = makeLiquorDataSource()

    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
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

    public override func viewWillAppear(_ animated: Bool) {
        if case .keyword(let keyword) = viewModel.mode {
            setUpNavigationBar()
            navigationItem.title = "#\(keyword.name)"
        } else {
            navigationController?.navigationBar.isHidden = true
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpCollectionViews()
        bind()
        layout()
        LiquorListSection.allCases.forEach {
            applyDataSource(section: $0)
        }
        viewModel.viewDidLoad()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    private func setUpNavigationBar() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundColor = .white
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .black
    }

    private func setUpCollectionViews() {
        keywordCollectionView.dataSource = keywordDataSource
        liquorCollectionView.dataSource = liquorDataSource
    }

    private func bind() {
        viewModel.rxLiquorCount
            .asDriver(onErrorJustReturn: 0)
            .map { "상품 \($0)" }
            .drive(productCountLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.isUpdating
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] isUpdating in
                if isUpdating {
                    self?.loadingIndicator.startAnimating()
                    self?.keywordCollectionView.isUserInteractionEnabled = false
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.keywordCollectionView.isUserInteractionEnabled = true
                }
            }
            .disposed(by: disposeBag)

        scrollView.rx.reachedBottom()
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel.fetchLiquors()
            }).disposed(by: disposeBag)

        keywordCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] indexPath in
                if let currentSelectedKewyord = self?.viewModel.rxSelectedKeyword.value,
                   let selectedKeyword = self?.keywordDataSource.itemIdentifier(for: indexPath),
                   selectedKeyword == currentSelectedKewyord  {
                    return
                }
                self?.viewModel.rxSelectedKeyword.accept(self?.viewModel.rxKeywords.value[indexPath.row])
            }
            .disposed(by: disposeBag)

        keywordCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.keywordCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        liquorCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.liquorCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        liquorCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] indexPath in
                guard let self = self else { return }
                let itemName = self.viewModel.rxLiquors.value[indexPath.row].name
                self.coordinator?.liquorItemSelected(itemName: itemName)
            }
            .disposed(by: disposeBag)

        categoryTableView.rx.itemSelected
            .asSignal(onErrorSignalWith: .just(IndexPath(row: 0, section: 0)))
            .emit { [weak self] indexPath in
                let liquorType = LiquorType.allCases[indexPath.row]
                self?.categoryModalView.isHidden = true
                self?.categoryLabel.text = liquorType.name
                self?.categoryLabel.font = .boldSystemFont(ofSize: 14)
                self?.viewModel.rxSelectedType.accept(liquorType)
            }
            .disposed(by: disposeBag)

        viewModel.rxLiquors.asDriver(onErrorJustReturn: [])
            .drive { [weak self] liquors in
                self?.applyDataSource(section: .liquors(liquors))
            }
            .disposed(by: disposeBag)

        viewModel.rxKeywords.asDriver(onErrorJustReturn: [])
            .drive { [weak self] keywords in
                self?.applyDataSource(section: .keywords(keywords))
            }
            .disposed(by: disposeBag)

        viewModel.rxSelectedKeyword
            .asDriver()
            .drive { [weak self] (keyword: Keyword?) in
                if let selectedCount = self?.keywordCollectionView.indexPathsForSelectedItems?.count,
                   selectedCount == 0 {
                    let indexPathToSelect = self?.keywordDataSource.indexPath(for: keyword ?? .others)
                    self?.keywordCollectionView.selectItem(at: indexPathToSelect, animated: true, scrollPosition: .centeredHorizontally)
                }
            }
            .disposed(by: disposeBag)
    }

    private func layout() {
        [scrollView, categoryModalView, loadingIndicator].forEach { view.addSubview($0) }

        categoryModalView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

        if case .search = viewModel.mode {
            [searchBar, keywordCollectionView, infoView, liquorCollectionView].forEach {
                outerStackView.addArrangedSubview($0)
            }
            keywordCollectionView.snp.makeConstraints {
                $0.height.equalTo(95)
            }
            outerStackView.setCustomSpacing(0, after: searchBar)
        } else {
            [infoView, liquorCollectionView].forEach {
                outerStackView.addArrangedSubview($0)
            }
        }
        liquorCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1) // trigger for estimate collectionView's size
        }
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

// MARK: - CategoryTableView DataSource & Delegate

extension LiquorListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LiquorType.allCases.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = LiquorType.allCases[indexPath.row].name
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        return cell
    }
}

extension LiquorListViewController: UISearchBarDelegate {

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
