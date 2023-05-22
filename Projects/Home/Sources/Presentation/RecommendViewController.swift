//
//  RecommendViewController.swift
//  Home
//
//  Created by 천수현 on 2023/05/22.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Design
import BaseDomain
import Kingfisher

public final class RecommendViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: RecommendViewModel

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let recommendLiquorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()

    private let recommendLiquorTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleLarge2)
        label.text = "나만을 위한 주류"
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray4.color
        label.text = "잠시만 기다려주세요"
        return label
    }()

    private lazy var recommendView: UIView = {
        let recommendView = UIView()
        [recommendLiquorImageView, recommendLiquorTitleLabel, subTitleLabel].forEach {
            recommendView.addSubview($0)
        }
        recommendLiquorImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(recommendLiquorImageView.snp.width)
        }
        recommendLiquorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recommendLiquorImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recommendLiquorTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        return recommendView
    }()

    private lazy var otherRecommendDataSource = makeOtherRecommendDataSource()
    private let otherRecommendTitleBar = TitleBar(title: "Other Recommends", subTitle: "당신이 관심있을 법한 다른 상품들")
    private lazy var otherRecommendCollectionView = UICollectionView(frame: .zero,
                                                                     collectionViewLayout: otherRecommendCollectionViewLayout())

    public init(viewModel: RecommendViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        navigationItem.title = "나만을 위한 주류"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpOthersCollectionView()
        layout()
        bind()
        viewModel.fetchLiquors()
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

    private func setUpOthersCollectionView() {
        otherRecommendCollectionView.register(LiquorCell.self, forCellWithReuseIdentifier: LiquorCell.reuseIdentifier)
    }

    private func bind() {
        viewModel.rxLiquors.asDriver()
            .drive { [weak self] liquors in
                self?.applyDataSource(liquors: liquors)
            }
            .disposed(by: disposeBag)
    }

    private func layout() {
        [scrollView, loadingIndicator].forEach { view.addSubview($0) }
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        otherRecommendCollectionView.snp.makeConstraints {
            $0.height.equalTo(310)
        }
        [recommendView, otherRecommendTitleBar, otherRecommendCollectionView].forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private enum OtherRecommendSection {
        case main
    }

    private func makeOtherRecommendDataSource() -> UICollectionViewDiffableDataSource<OtherRecommendSection, Liquor> {
        return .init(collectionView: otherRecommendCollectionView) { collectionView, indexPath, liquor in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiquorCell.reuseIdentifier, for: indexPath) as? LiquorCell else { return UICollectionViewCell() }
            cell.setUpContents(liquor: liquor)
            return cell
        }
    }

    private func otherRecommendCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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

    private func applyDataSource(liquors: [Liquor]) {
        guard !liquors.isEmpty else { return }
        var liquors = liquors
        let mainLiquor = liquors.removeFirst()
        recommendLiquorImageView.kf.setImage(with: URL(string: mainLiquor.imagePath))
        recommendLiquorTitleLabel.text = mainLiquor.name
        subTitleLabel.text = "\(mainLiquor.dosage) | \(mainLiquor.alcoholPercentage)"
        var otherRecommendSnapShot = NSDiffableDataSourceSnapshot<OtherRecommendSection, Liquor>()
        otherRecommendSnapShot.appendSections([.main])
        otherRecommendSnapShot.appendItems(liquors)
        self.otherRecommendDataSource.apply(otherRecommendSnapShot)
    }
}
