//
//  KeywordCell.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/06.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Kingfisher
import HomeDomain
import Design

final class KeywordCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: KeywordCell.self)

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = DesignAsset.Colors.gray3.color.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonSmall)
        label.textColor = DesignAsset.Colors.gray5.color
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(keyword: Keyword) {
        titleLabel.text = "#\(keyword.name)"
        imageView.image = keyword.image
    }

    private func layout() {
        [imageView, titleLabel].forEach { contentView.addSubview($0) }
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom)
        }
    }
}
