//
//  LiquorCell.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import LiquorDomain
import Kingfisher

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
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        [titleLabel, infoLabel, keywordLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private var imageLoadTask: DownloadTask?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageLoadTask?.cancel()
    }

    func setUpContents(liquor: Liquor) {
        imageLoadTask = liquorImageView.kf.setImage(with: URL(string: liquor.imagePath))
        titleLabel.text = liquor.name
        infoLabel.text = "\(liquor.dosage) | \(liquor.alcoholPercentage)"
        keywordLabel.text = liquor.keywords.map { return "#\($0.name)" }.joined(separator: " ")
        [titleLabel, infoLabel, keywordLabel].forEach { $0.lineBreakMode = .byTruncatingTail }
    }

    private func layout() {
        [liquorImageView, labelStackView].forEach { contentView.addSubview($0) }
        liquorImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(liquorImageView.snp.width)
        }
        labelStackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(liquorImageView.snp.bottom).offset(10)
        }
    }
}
