//
//  LiquorDetailViewController.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/26.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift

final class LiquorDetailViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        return stackView
    }()
    private let liquorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let liquorTitleLabel = UILabel(title: "text", font: .titleLarge2, textColor: DesignAsset.gray7.color)
    private let breweryTitleLabel = UILabel(title: "text", font: .bodySmall, textColor: DesignAsset.gray5.color)
    private let keywordLabel = UILabel(title: "text", font: .buttonMedium, textColor: .systemBlue)
    private lazy var titleView: UIView = {
        let titleView = UIView()
        [liquorTitleLabel, breweryTitleLabel, keywordLabel].forEach {
            titleView.addSubview($0)
        }
        liquorTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(20)
        }
        breweryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(liquorTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(breweryTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(20)
        }
        return titleView
    }()

    private let wooriSoolInfoLabel = UILabel(title: "우리술 정보", font: .captionLarge, textColor: DesignAsset.gray5.color)
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
            $0.bottom.equalToSuperview().inset(20)
        }
        return liquorInfoView
    }()

    private let wooriSoolDescriptionLabel = UILabel(title: "우리술 소개", font: .captionLarge, textColor: DesignAsset.gray5.color)
    private let descriptionInfoView = LiquorDetailInfoView(title: "132", description: "소개내용")
    private lazy var liquorDescriptionView: UIView = {
        let liquorDescriptionView = UIView()
        [wooriSoolDescriptionLabel, descriptionInfoView].forEach { liquorDescriptionView.addSubview($0) }
        wooriSoolDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(13)
        }
        descriptionInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(wooriSoolDescriptionLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(20)
        }
        return liquorDescriptionView
    }()

    private let foodLabel = UILabel(title: "어울리는 음식", font: .captionLarge, textColor: DesignAsset.gray5.color)
    private let foodInfoView = LiquorDetailInfoView(title: "text", description: "text")
    private lazy var foodView: UIView = {
        let foodView = UIView()
        [foodLabel, foodInfoView].forEach { foodView.addSubview($0) }
        foodLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(20)
        }
        foodInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(foodLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(20)
        }
        return foodView
    }()

    private let breweryInfoLabel = UILabel(title: "양조장 정보", font: .captionLarge, textColor: DesignAsset.gray5.color)
    private let breweryNameInfoView = LiquorDetailInfoView(title: "text", description: "text")
    private let breweryAddressInfoView = LiquorDetailInfoView(title: "text", description: "text")
    private let breweryHomePageInfoView = LiquorDetailInfoView(title: "text", description: "text")
    private let breweryPhoneNumberInfoView = LiquorDetailInfoView(title: "text", description: "text")
    private lazy var breweryView: UIView = {
        let breweryView = UIView()
        [breweryInfoLabel, breweryNameInfoView, breweryAddressInfoView,
         breweryHomePageInfoView, breweryPhoneNumberInfoView].forEach { breweryView.addSubview($0) }
        breweryInfoLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(20)
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
            $0.bottom.equalToSuperview().inset(20)
        }
        return breweryView
    }()

    private let sourceLabel = UILabel(title: "자료 출처", font: .captionLarge, textColor: DesignAsset.gray5.color)
    private let sourceInfoView = LiquorDetailInfoView(title: "https://thesool.com", description: "text")
    private lazy var sourceView: UIView = {
        let sourceView = UIView()
        [sourceLabel, sourceInfoView].forEach { sourceView.addSubview($0) }
        sourceLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalToSuperview().inset(20)
        }
        sourceInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13)
            $0.top.equalTo(sourceLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(20)
        }
        return sourceView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
    }

    private func layout() {
        view.addSubview(scrollView)
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
            sourceView
        ].forEach {
            outerStackView.addArrangedSubview($0)
        }

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
