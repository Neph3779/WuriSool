//
//  TitleBar.swift
//  HomePresentation
//
//  Created by 천수현 on 2023/04/06.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Design

final class TitleBar: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .titleMedium)
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .captionMedium)
        label.textColor = DesignAsset.gray4.color
        return label
    }()

    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        subTitleLabel.text = subTitle
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [titleLabel, subTitleLabel].forEach {
            addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        subTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
        }
    }
}
