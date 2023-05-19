//
//  LiquorDetailInfoView.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/26.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class LiquorDetailInfoView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .captionLarge)
        label.textColor = DesignAsset.Colors.gray4.color
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .bodySmallOverTwoLine)
        label.numberOfLines = 0
        label.textColor = DesignAsset.Colors.gray6.color
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        [titleLabel, descriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.15)
        }
        return stackView
    }()

    init(title: String? = nil, description: String? = nil) {
        super.init(frame: .zero)
        layout()
        titleLabel.isHidden = title == nil
        titleLabel.text = title
        descriptionLabel.text = description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
