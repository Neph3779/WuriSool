//
//  WatchViewModel.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WatchDomain

final class WatchViewModel {
    private let repository: WatchRepositoryInterface

    init(repository: WatchRepositoryInterface) {
        self.repository = repository
    }
}
