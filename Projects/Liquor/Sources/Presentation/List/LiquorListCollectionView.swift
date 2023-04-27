//
//  MyCollectionView.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/20.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LiquorListCollectionView: UICollectionView {

    var contentSizeDidChanged = PublishRelay<CGSize>()

    override var contentSize: CGSize {
        didSet {
            contentSizeDidChanged.accept(contentSize)
        }
    }
}
