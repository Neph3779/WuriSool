//
//  DIContainer.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import WatchDomain
import WatchData
import WatchPresentation

final class DIContainer {

    func makeWatchRepository() -> WatchRepository {
        return WatchRepository()
    }
    func makeWatchViewModel() -> WatchViewModel {
        return WatchViewModel(repository: makeWatchRepository())
    }
    func makeWatchViewController() -> WatchViewController {
        return WatchViewController(viewModel: makeWatchViewModel())
    }
}
