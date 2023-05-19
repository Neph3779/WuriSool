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

    override var isSelected: Bool {
        didSet {
            if isSelected {
                keywordLabel.textColor = DesignAsset.Colors.gray7.color
                bottomLine.snp.remakeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(2)
                }
                bottomLine.backgroundColor = DesignAsset.Colors.gray7.color
            } else {
                keywordLabel.textColor = DesignAsset.Colors.gray4.color
                bottomLine.snp.remakeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(1)
                }
                bottomLine.backgroundColor = DesignAsset.Colors.gray1.color
            }
        }
    }

    private let keywordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderColor = DesignAsset.Colors.gray3.color.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DesignAsset.Colors.gray4.color
        label.applyFont(font: .buttonSmall)
        return label
    }()

    private let bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = DesignAsset.Colors.gray1.color
        return line
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(keyword: Keyword) {
        keywordImageView.image = keyword.image
        keywordLabel.text = "#\(keyword.name)"
    }

    private func layout() {
        [keywordImageView, keywordLabel, bottomLine].forEach {
            contentView.addSubview($0)
        }
        keywordImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-3)
            $0.top.equalToSuperview().inset(5)
            $0.width.height.equalTo(50)
        }
        keywordLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-3)
            $0.top.equalTo(keywordImageView.snp.bottom).offset(5)
        }
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
