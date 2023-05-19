//
//  ProductCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import Kingfisher

final class ProductCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: ProductCell.self)
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .captionLarge)
        label.textColor = DesignAsset.Colors.gray5.color
        label.text = "탁주"
        return label
    }()

    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleSmall)
        label.textColor = DesignAsset.Colors.gray7.color
        return label
    }()

    private let productInfoLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonMedium)
        return label
    }()

    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = DesignAsset.Colors.gray1.color
        return divider
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(liquor: LiquorOverview) {
        productImageView.kf.setImage(with: URL(string: liquor.imagePath))
        productNameLabel.text = liquor.name
        productInfoLabel.text = "\(liquor.alcoholPercentage) | \(liquor.dosage)"
        productInfoLabel.changeColor(targetString: "|", color: DesignAsset.Colors.gray3.color)
        categoryLabel.text = liquor.liquorType.name
    }

    private func layout() {
        [productImageView, categoryLabel, productNameLabel, productInfoLabel, divider].forEach {
            contentView.addSubview($0)
        }

        divider.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        productImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
            $0.bottom.equalTo(divider.snp.top).offset(-16)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(productImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(productImageView.snp.top).offset(10)
        }

        productNameLabel.snp.makeConstraints {
            $0.leading.equalTo(productImageView.snp.trailing).offset(12)
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
        }

        productInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(productImageView.snp.trailing).offset(12)
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8)
        }
    }
}

fileprivate extension UILabel {
    func changeColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}
