//
//  DIContainer.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import LiquorDomain
import LiquorPresentation
import LiquorData

final class DIContainer {
    func makeLiquorRepository() -> LiquorRepositoryInterface {
        return LiquorRepository()
    }

    func makeLiquorViewModel() -> LiquorListViewModel {
        return LiquorListViewModel(repository: makeLiquorRepository())
    }

    func makeLiquorViewController() -> LiquorListViewController {
        return LiquorListViewController(viewModel: makeLiquorViewModel())
    }
}
