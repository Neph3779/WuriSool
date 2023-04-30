//
//  SizableCollectionView.swift
//  Design
//
//  Created by 천수현 on 2023/04/30.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class SizableCollectionView: UICollectionView {

    open var contentSizeDidChanged = PublishRelay<CGSize>()

    open override var contentSize: CGSize {
        didSet {
            contentSizeDidChanged.accept(contentSize)
        }
    }
}
