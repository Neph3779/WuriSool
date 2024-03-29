//
//  LiquorDetailViewController.swift
//  Liquor
//
//  Created by 천수현 on 1523/04/26.
//  Copyright © 1523 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import LiquorDomain

public final class LiquorDetailViewController: UIViewController {

    var coordinator: LiquorCoordinatorInterface?
    private let viewModel: LiquorDetailViewModel
    private let disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
        scrollView.backgroundColor = DesignAsset.Colors.gray0.color
        return scrollView
    }()
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = DesignAsset.Colors.gray1.color
        stackView.insetsLayoutMarginsFromSafeArea = true
        return stackView
    }()
    private let liquorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let liquorTitleLabel = UILabel(title: "text", font: .titleLarge2, textColor: DesignAsset.Colors.gray7.color)
    private let breweryTitleLabel = UILabel(title: "text", font: .bodySmall, textColor: DesignAsset.Colors.gray5.color)
    private let breweryTitleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.applyFont(font: .bodySmall)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(DesignAsset.Colors.gray5.color, for: .normal)
        return button
    }()
    private let keywordLabel = UILabel(title: "text", font: .captionLarge, textColor: DesignAsset.Colors.gray7.color)
    private lazy var titleView: UIView = {
        let titleView = UIView()
        [liquorTitleLabel, breweryTitleButton, keywordLabel].forEach {
            titleView.addSubview($0)
        }
        liquorTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(15)
        }
        breweryTitleButton.snp.makeConstraints {
            $0.top.equalTo(liquorTitleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(13)
        }
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(breweryTitleButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(15)
        }
        return titleView
    }()

    private let wooriSoolInfoLabel = UILabel(title: "우리술 정보", font: .buttonMedium, textColor: DesignAsset.Colors.gray6.color)
    private let liquorTypeInfoView = LiquorDetailInfoView(title: "주종", description: "text")
    private let dosageInfoView = LiquorDetailInfoView(title: "용량", description: "text")
    private let alcoholPercentageInfoView = LiquorDetailInfoView(title: "도수", description: "text")
    private let awardInfoView = LiquorDetailInfoView(title: "수상내역", description: "text")
    private let ingredientInfoView = LiquorDetailInfoView(title: "원재료", description: "text")
    private lazy var liquorInfoView: UIView = {
        let liquorInfoView = UIView()
        [wooriSoolInfoLabel, liquorTypeInfoView, dosageInfoView,
         alcoholPercentageInfoView, awardInfoView, ingredientInfoView].forEach {
            liquorInfoView.addSubview($0)
        }
        wooriSoolInfoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(10)
        }
        liquorTypeInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(wooriSoolInfoLabel.snp.bottom).offset(10)
        }
        dosageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(liquorTypeInfoView.snp.bottom).offset(4)
        }
        alcoholPercentageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(dosageInfoView.snp.bottom).offset(4)
        }
        awardInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(alcoholPercentageInfoView.snp.bottom).offset(4)
        }
        ingredientInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(awardInfoView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(15)
        }
        return liquorInfoView
    }()

    private let wooriSoolDescriptionLabel = UILabel(title: "우리술 소개", font: .buttonMedium, textColor: DesignAsset.Colors.gray6.color)
    private let descriptionInfoView = LiquorDetailInfoView(title: nil, description: "소개내용")
    private lazy var liquorDescriptionView: UIView = {
        let liquorDescriptionView = UIView()
        [wooriSoolDescriptionLabel, descriptionInfoView].forEach { liquorDescriptionView.addSubview($0) }
        wooriSoolDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        descriptionInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(wooriSoolDescriptionLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(15)
        }
        return liquorDescriptionView
    }()

    private let foodLabel = UILabel(title: "어울리는 음식", font: .buttonMedium, textColor: DesignAsset.Colors.gray6.color)
    private let foodInfoView = LiquorDetailInfoView(title: nil, description: "text")
    private lazy var foodView: UIView = {
        let foodView = UIView()
        [foodLabel, foodInfoView].forEach { foodView.addSubview($0) }
        foodLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(10)
        }
        foodInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(foodLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(15)
        }
        return foodView
    }()

    private let breweryInfoLabel = UILabel(title: "양조장 정보", font: .buttonMedium, textColor: DesignAsset.Colors.gray6.color)
    private let breweryNameInfoView = LiquorDetailInfoView(title: "양조장명", description: "text")
    private let breweryAddressInfoView = LiquorDetailInfoView(title: "주소", description: "text")
    private let breweryHomePageInfoView = LiquorDetailInfoView(title: "홈페이지", description: "text")
    private let breweryPhoneNumberInfoView = LiquorDetailInfoView(title: "문의", description: "text")
    private lazy var breweryView: UIView = {
        let breweryView = UIView()
        [breweryInfoLabel, breweryNameInfoView, breweryAddressInfoView,
         breweryHomePageInfoView, breweryPhoneNumberInfoView].forEach { breweryView.addSubview($0) }
        breweryInfoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(10)
        }
        breweryNameInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryInfoLabel.snp.bottom).offset(10)
        }
        breweryAddressInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryNameInfoView.snp.bottom).offset(4)
        }
        breweryHomePageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryAddressInfoView.snp.bottom).offset(4)
        }
        breweryPhoneNumberInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryHomePageInfoView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(15)
        }
        return breweryView
    }()

    private let sourceLabel = UILabel(title: "자료 출처", font: .captionLarge, textColor: DesignAsset.Colors.gray5.color)
    private let sourceInfoView = LiquorDetailInfoView(title: nil, description: "https://thesool.com")
    private lazy var sourceView: UIView = {
        let sourceView = UIView()
        [sourceLabel, sourceInfoView].forEach { sourceView.addSubview($0) }
        sourceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(15)
        }
        sourceInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(sourceLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(15)
        }
        sourceInfoView.descriptionLabel.applyFont(font: .captionLarge)
        return sourceView
    }()

    private let naverShoppingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignAsset.Colors.naver.color
        button.setImage(DesignAsset.Images.naverShopping.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle("네이버 쇼핑", for: .normal)
        button.imageView?.setContentHuggingPriority(.required, for: .horizontal)
        button.titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let kakaoShoppingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = DesignAsset.Colors.kakao.color
        button.setImage(DesignAsset.Images.kakaoShopping.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        button.setTitle("카카오 쇼핑", for: .normal)
        return button
    }()

    private lazy var shoppingButtonView: UIView = {
        let shoppingView = UIView()
        shoppingView.backgroundColor = .white
        let divider = UIView()
        divider.backgroundColor = DesignAsset.Colors.gray1.color
        shoppingView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        [naverShoppingButton, kakaoShoppingButton].forEach {
            shoppingView.addSubview($0)
            $0.layer.cornerRadius = 10
            $0.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
            $0.imageEdgeInsets = .init(top: 0, left: -60, bottom: 0, right: 0)
            $0.titleLabel?.applyFont(font: .buttonLarge)
            $0.adjustsImageWhenHighlighted = false
        }
        naverShoppingButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(34)
        }
        kakaoShoppingButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(34)
            $0.leading.equalTo(naverShoppingButton.snp.trailing).offset(10)
            $0.width.equalTo(naverShoppingButton)
        }
        kakaoShoppingButton.setTitleColor(.black, for: .normal)
        return shoppingView
    }()

    public init(viewModel: LiquorDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true

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
        bind()
        layout()
    }

    private func setUpNavigationBar() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.backgroundColor = .white
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = standardAppearance

        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundColor = .white
        scrollEdgeAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonDisplayMode = .minimal
    }

    private func bind() {
        viewModel.liquor
            .asDriver()
            .drive { [weak self] (liquor: Liquor) in
                self?.navigationItem.title = liquor.name
                self?.liquorImageView.kf.setImage(with: URL(string: liquor.imagePath))
                self?.liquorTitleLabel.text = liquor.name
                self?.breweryTitleLabel.text = liquor.brewery.name
                self?.breweryTitleButton.setTitle(liquor.brewery.name, for: .normal)
                self?.keywordLabel.text = liquor.keywords.map { "#\($0.name)" }.joined(separator: " ")
                self?.liquorTypeInfoView.descriptionLabel.text = liquor.type.name
                self?.dosageInfoView.descriptionLabel.text = liquor.dosage
                self?.alcoholPercentageInfoView.descriptionLabel.text = liquor.alcoholPercentage
                self?.awardInfoView.descriptionLabel.text = liquor.award
                self?.ingredientInfoView.descriptionLabel.text = liquor.ingredients
                self?.descriptionInfoView.descriptionLabel.text = liquor.description
                self?.foodInfoView.descriptionLabel.text = liquor.foods
                self?.breweryNameInfoView.descriptionLabel.text = liquor.brewery.name
                self?.breweryAddressInfoView.descriptionLabel.text = liquor.brewery.address
                self?.breweryHomePageInfoView.descriptionLabel.text = liquor.brewery.homePage
                self?.breweryPhoneNumberInfoView.descriptionLabel.text = liquor.brewery.phoneNumber
            }
            .disposed(by: disposeBag)

        breweryTitleButton.rx.tap
            .asSignal()
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.breweryTapped(breweryName: self.viewModel.liquor.value.brewery.name)
            }
            .disposed(by: disposeBag)

        naverShoppingButton.rx.tap
            .asSignal()
            .emit { [weak self] _ in
                if let url = URL(string: "https://msearch.shopping.naver.com/search/all?query=\(self?.viewModel.liquor.value.name ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
                          UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)

        kakaoShoppingButton.rx.tap
            .asSignal()
            .emit { [weak self] _ in
                if let url = URL(string: "https://store.kakao.com/search/result/product?q=\(self?.viewModel.liquor.value.name ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
                          UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .disposed(by: disposeBag)
    }

    private func layout() {
        [scrollView, shoppingButtonView].forEach {
            view.addSubview($0)
        }
        shoppingButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view)
            $0.height.equalTo(90)
        }
        scrollView.addSubview(outerStackView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view)
            $0.bottom.equalTo(view)
        }
        outerStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.top.bottom.equalToSuperview()
        }
        [
            liquorImageView,
            titleView,
            liquorInfoView,
            liquorDescriptionView,
            foodView,
            breweryView,
            sourceView
        ].forEach {
            outerStackView.addArrangedSubview($0)
            $0.backgroundColor = .white
        }

        sourceView.backgroundColor = DesignAsset.Colors.gray0.color

        liquorImageView.snp.makeConstraints {
            $0.height.equalTo(view).multipliedBy(0.4)
        }
    }
}

fileprivate extension UILabel {
    convenience init(title: String?, font: TextStyles, textColor: UIColor) {
        self.init()
        self.text = title
        self.textColor = textColor
        applyFont(font: font)
    }
}
