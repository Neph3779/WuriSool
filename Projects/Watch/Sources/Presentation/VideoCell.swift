//
//  VideoCell.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class VideoCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: VideoCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
