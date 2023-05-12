//
//  InfoView.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Kingfisher

final class InfoView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmall)
        label.textColor = DesignAsset.Colors.gray6.color
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()

    init(image: UIImage?, description: String) {
        super.init(frame: .zero)
        imageView.image = image
        descriptionLabel.text = description
        backgroundColor = .white
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [imageView, descriptionLabel].forEach {
            addSubview($0)
        }
        imageView.snp.makeConstraints {
            $0.top.bottom.equalTo(descriptionLabel)
            $0.leading.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(13)
        }
    }
}
