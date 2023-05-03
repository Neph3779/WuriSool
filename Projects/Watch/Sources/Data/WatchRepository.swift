//
//  WatchRepository.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Network
import WatchDomain

final class WatchRepository: WatchRepositoryInterface {

    private let firebaseRepository: FirebaseRepositoryInterface

    init(firebaseRepository: FirebaseRepositoryInterface = FirebaseRepository()) {
        self.firebaseRepository = firebaseRepository
    }
}
