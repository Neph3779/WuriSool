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

final class LiquorDetailViewController: UIViewController {

    var coordinator: (any LiquorCoordinatorInterface)?
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
    private let keywordLabel = UILabel(title: "text", font: .buttonMedium, textColor: .systemBlue)
    private lazy var titleView: UIView = {
        let titleView = UIView()
        [liquorTitleLabel, breweryTitleLabel, keywordLabel].forEach {
            titleView.addSubview($0)
        }
        liquorTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(15)
        }
        breweryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(liquorTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(breweryTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(15)
        }
        return titleView
    }()

    private let wooriSoolInfoLabel = UILabel(title: "우리술 정보", font: .captionLarge, textColor: DesignAsset.Colors.gray5.color)
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
            $0.top.equalToSuperview().inset(15)
        }
        liquorTypeInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(wooriSoolInfoLabel.snp.bottom).offset(8)
        }
        dosageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(liquorTypeInfoView.snp.bottom).offset(8)
        }
        alcoholPercentageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(dosageInfoView.snp.bottom).offset(8)
        }
        awardInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(alcoholPercentageInfoView.snp.bottom).offset(8)
        }
        ingredientInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(awardInfoView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(15)
        }
        return liquorInfoView
    }()

    private let wooriSoolDescriptionLabel = UILabel(title: "우리술 소개", font: .captionLarge, textColor: DesignAsset.Colors.gray5.color)
    private let descriptionInfoView = LiquorDetailInfoView(title: nil, description: "소개내용")
    private lazy var liquorDescriptionView: UIView = {
        let liquorDescriptionView = UIView()
        [wooriSoolDescriptionLabel, descriptionInfoView].forEach { liquorDescriptionView.addSubview($0) }
        wooriSoolDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        descriptionInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(wooriSoolDescriptionLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(15)
        }
        return liquorDescriptionView
    }()

    private let foodLabel = UILabel(title: "어울리는 음식", font: .captionLarge, textColor: DesignAsset.Colors.gray5.color)
    private let foodInfoView = LiquorDetailInfoView(title: nil, description: "text")
    private lazy var foodView: UIView = {
        let foodView = UIView()
        [foodLabel, foodInfoView].forEach { foodView.addSubview($0) }
        foodLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(15)
        }
        foodInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(foodLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(15)
        }
        return foodView
    }()

    private let breweryInfoLabel = UILabel(title: "양조장 정보", font: .captionLarge, textColor: DesignAsset.Colors.gray5.color)
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
            $0.top.equalToSuperview().inset(15)
        }
        breweryNameInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryInfoLabel.snp.bottom).offset(8)
        }
        breweryAddressInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryNameInfoView.snp.bottom).offset(8)
        }
        breweryHomePageInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryAddressInfoView.snp.bottom).offset(8)
        }
        breweryPhoneNumberInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(breweryHomePageInfoView.snp.bottom).offset(8)
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
        button.setTitle("네이버 쇼핑으로 이동", for: .normal)
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
        button.setTitle("카카오 쇼핑으로 이동", for: .normal)
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
            $0.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
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

    init(viewModel: LiquorDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        bind()
        layout()
    }

    private func bind() {
        viewModel.liquor
            .share()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] liquor in
                self?.liquorImageView.kf.setImage(with: URL(string: liquor.imagePath))
            })
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.name }
            .drive(liquorTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.brewery.name }
            .drive(breweryTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.keywords.map { "#\($0.name)" }.joined(separator: " ") }
            .drive(keywordLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.type.name }
            .drive(liquorTypeInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.dosage }
            .drive(dosageInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.alcoholPercentage }
            .drive(alcoholPercentageInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.award }
            .drive(awardInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.ingredients }
            .drive(ingredientInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.description }
            .drive(descriptionInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.foods }
            .drive(foodInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.brewery.name }
            .drive(breweryNameInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.brewery.address }
            .drive(breweryAddressInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.brewery.homePage }
            .drive(breweryHomePageInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.liquor
            .asDriver()
            .map { $0.brewery.phoneNumber }
            .drive(breweryPhoneNumberInfoView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func layout() {
        [scrollView, shoppingButtonView].forEach {
            view.addSubview($0)
        }
        shoppingButtonView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
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
