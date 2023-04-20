//
//  KeywordCell.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import LiquorDomain
import Kingfisher

final class KeywordCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: KeywordCell.self)

    private let keywordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        return imageView
    }()

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DesignAsset.gray4.color
        label.applyFont(font: .buttonSmall)
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
        keywordImageView.kf.setImage(with: URL(string: keyword.imagePath))
        keywordLabel.text = "#\(keyword.name)"
    }

    private func layout() {
        [keywordImageView, keywordLabel].forEach {
            contentView.addSubview($0)
        }
        keywordImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(15)
            $0.width.height.equalTo(50)
        }
        keywordLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(keywordImageView.snp.bottom).offset(5)
        }
    }
}
