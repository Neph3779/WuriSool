//
//  LiquorCategoryCell.swift
//  Liquor
//
//  Created by 천수현 on 2023/05/15.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class LiquorCategoryCell: UITableViewCell {

    static let reuseIdentifier = String(describing: LiquorCategoryCell.self)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.applyFont(font: .buttonLarge)
        label.textAlignment = .center
        label.textColor = DesignAsset.Colors.gray5.color
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(title: String) {
        titleLabel.text = title
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
