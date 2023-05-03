//
//  DIContainer.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BreweryDomain
import BreweryData
import BreweryPresentation

final class DIContainer {

    func makeBreweryRepository() -> BreweryRepositoryInterface {
        return BreweryRepository()
    }

    func makeBreweryListViewModel() -> BreweryListViewModel {
        return BreweryListViewModel(repository: makeBreweryRepository())
    }

    func makeBreweryListViewController() -> BreweryListViewController {
        return BreweryListViewController(viewModel: makeBreweryListViewModel())
    }

    func makeBreweryDetailViewModel(name: String) -> BreweryDetailViewModel {
        return BreweryDetailViewModel(name: name, repository: makeBreweryRepository())
    }

    func makeBreweryDetailViewController(name: String) -> BreweryDetailBaseViewController {
        return BreweryDetailBaseViewController(viewModel: makeBreweryDetailViewModel(name: name))
    }
}
