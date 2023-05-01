//
//  BreweryListCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import Kingfisher

final class BreweryListCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: BreweryListCell.self)

    private let breweryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleSmall)
        label.text = "가게이름"
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray4.color
        label.text = "가게 주소"
        return label
    }()

    private lazy var labelOuterView: UIView = {
        let outerView = UIView()
        [titleLabel, addressLabel].forEach {
            outerView.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = DesignAsset.Colors.gray1.color.cgColor
        outerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        outerView.layer.cornerRadius = 6
        return outerView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(brewery: Brewery) {
        breweryImageView.kf.setImage(with: URL(string: brewery.imagePath))
        titleLabel.text = brewery.name
        addressLabel.text = brewery.address
    }

    private func layout() {
        [breweryImageView, labelOuterView].forEach {
            contentView.addSubview($0)
        }
        breweryImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        labelOuterView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(breweryImageView.snp.bottom)
        }
    }
}
