//
//  CategoryCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain

final class CategoryCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: CategoryCell.self)

    override var isSelected: Bool {
        didSet {
            isSelected ? setUpSelected() : setUpDeselected()
        }
    }

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = DesignAsset.Colors.gray4.color
        label.applyFont(font: .buttonMedium)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setUpDeselected()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpContents(category: LiquorType) {
        categoryLabel.text = category.name
    }

    private func layout() {
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

    private func setUpDeselected() {
        layer.cornerRadius = 8
        layer.borderColor = DesignAsset.Colors.gray2.color.cgColor
        categoryLabel.textColor = DesignAsset.Colors.gray4.color
        layer.borderWidth = 1
        clipsToBounds = true
    }

    private func setUpSelected() {
        layer.cornerRadius = 8
        layer.borderColor = DesignAsset.Colors.gray5.color.cgColor
        layer.borderWidth = 2
        categoryLabel.textColor = DesignAsset.Colors.gray7.color
        clipsToBounds = true
    }
}
