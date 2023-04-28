//
//  BreweryListCell.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryListCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: BreweryListCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
