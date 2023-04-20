//
//  MyCollectionView.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/20.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class LiquorListCollectionView: UICollectionView {

    public var contentSizeDidChanged: ((CGSize) -> Void)?

    override var contentSize: CGSize {
        didSet {
            contentSizeDidChanged?(contentSize)
        }
    }
}
