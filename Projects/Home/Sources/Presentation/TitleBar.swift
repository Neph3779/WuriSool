//
//  TitleBar.swift
//  HomePresentation
//
//  Created by 천수현 on 2023/04/06.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class TitleBar: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
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
            $0.leading.top.trailing.equalToSuperview().inset(5)
        }

        subTitleLabel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(5)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
