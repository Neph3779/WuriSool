//
//  LiquorCell.swift
//  Home
//
//  Created by 천수현 on 2023/04/06.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Kingfisher
import HomeDomain
import Design

final class LiquorCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: LiquorCell.self)

    private let liquorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleSmall)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(liquor: Liquor) {
        liquorImageView.kf.setImage(with: URL(string: liquor.imagePath))
        titleLabel.text = liquor.name
        subTitleLabel.text = "\(liquor.dosage) | \(liquor.alcoholPercentage)"
    }

    private func layout() {
        [liquorImageView, titleLabel, subTitleLabel].forEach {
            addSubview($0)
        }

        liquorImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(liquorImageView.snp.width).multipliedBy(1.8)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(liquorImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
