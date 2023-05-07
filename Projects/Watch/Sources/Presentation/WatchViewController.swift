//
//  WatchViewController.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import WatchDomain
import RxSwift
import RxCocoa
import SnapKit

final class WatchViewController: UIViewController {

    private let viewModel: WatchViewModel
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
        stackView.distribution = .fill
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        return stackView
    }()

    private lazy var categoryCollectionView: SizableCollectionView = {
        let collectionView = SizableCollectionView(frame: .zero, collectionViewLayout: categoryCollectionViewLayout())
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    private lazy var categoryDataSource = makeCategoryDataSource()

    private lazy var videoCollectionView: SizableCollectionView = {
        let collectionView = SizableCollectionView(frame: .zero, collectionViewLayout: videoCollectionViewLayout())
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 34, right: 0)
        return collectionView
    }()

    private lazy var videoDataSource = makeVideoDataSource()

    init(viewModel: WatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpCollectionViews()
        bind()
        layout()
        applyDataSource(section: .category(LiquorChannel.allCases))
        categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }

    private func setUpCollectionViews() {
        categoryCollectionView.dataSource = categoryDataSource
        videoCollectionView.dataSource = videoDataSource
    }

    private func bind() {
        viewModel.videos.asDriver()
            .drive { [weak self] (videos: [YoutubeVideo]) in
                self?.applyDataSource(section: .video(videos))
            }
            .disposed(by: disposeBag)
        categoryCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 0 {
                    self?.categoryCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        videoCollectionView.contentSizeDidChanged
            .asSignal()
            .emit { [weak self] size in
                if size.height > 10 {
                    self?.videoCollectionView.snp.remakeConstraints {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            .disposed(by: disposeBag)

        videoCollectionView.rx.itemSelected
            .asSignal()
            .emit { [weak self] indexPath in
                if let id = self?.viewModel.videos.value[indexPath.row].items.first?.id {
                    if let youtubeURL = URL(string: "youtube://" + id),
                       UIApplication.shared.canOpenURL(youtubeURL) {
                        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
                    } else if let url = URL(string: "http://www.youtube.com/watch?v=" + id) {
                        UIApplication.shared.open(url)
                    }
                }
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
        [categoryCollectionView, videoCollectionView].forEach {
            outerStackView.addArrangedSubview($0)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.height.equalTo(70)
        }
        videoCollectionView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(1) // trigger for estimate collectionView's size
        }
    }
}

// MARK: - CollectionView Layout

extension WatchViewController {
    private func categoryCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(70), heightDimension: .estimated(40)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func videoCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView DataSource

extension WatchViewController {
    enum CategorySeciton {
        case main
    }

    private func makeCategoryDataSource() -> UICollectionViewDiffableDataSource<CategorySeciton, LiquorChannel> {
        return .init(collectionView: categoryCollectionView) { collectionView, indexPath, channel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            cell.setUpContents(channel: channel)
            return cell
        }
    }

    enum Videosection {
        case main
    }

    private func makeVideoDataSource() -> UICollectionViewDiffableDataSource<Videosection, YoutubeVideo> {
        return .init(collectionView: videoCollectionView) { [weak self] collectionView, indexPath, video in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier, for: indexPath) as? VideoCell else { return UICollectionViewCell() }
            cell.setUpContents(video: video, channel: self?.viewModel.selectedChannel ?? .drinkHouse)
            return cell
        }
    }

    enum WatchListSection: CaseIterable {
        static var allCases: [WatchListSection] = [.category([]), .video([])]

        case category([LiquorChannel])
        case video([YoutubeVideo])
    }

    private func applyDataSource(section: WatchListSection) {
        switch section {
        case .category(let category):
            var categorySnapShot = NSDiffableDataSourceSnapshot<CategorySeciton, LiquorChannel>()
            categorySnapShot.deleteAllItems()
            categorySnapShot.appendSections([.main])
            categorySnapShot.appendItems(category)
            categoryDataSource.apply(categorySnapShot)
        case .video(let video):
            var videosnapShot = NSDiffableDataSourceSnapshot<Videosection, YoutubeVideo>()
            videosnapShot.deleteAllItems()
            videosnapShot.appendSections([.main])
            videosnapShot.appendItems(video)
            videoDataSource.apply(videosnapShot)
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
