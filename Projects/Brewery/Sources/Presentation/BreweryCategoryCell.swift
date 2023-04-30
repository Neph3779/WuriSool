//
//  BreweryCategoryCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/30.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryCategoryCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: BreweryCategoryCell.self)

    override var isSelected: Bool {
        didSet {
            if isSelected {
                addressLabel.textColor = DesignAsset.Colors.gray7.color
                bottomLine.snp.remakeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(2)
                }
                bottomLine.backgroundColor = DesignAsset.Colors.gray7.color
            } else {
                addressLabel.textColor = DesignAsset.Colors.gray4.color
                bottomLine.snp.remakeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(1)
                }
                bottomLine.backgroundColor = DesignAsset.Colors.gray1.color
            }
        }
    }

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = DesignAsset.Colors.gray4.color
        label.applyFont(font: .buttonLarge)
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

    func setUpContents(address: String) {
        addressLabel.text = address
    }

    private func layout() {
        [addressLabel, bottomLine].forEach {
            contentView.addSubview($0)
        }
        addressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(13)
        }
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
