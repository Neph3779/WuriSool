//
//  DIContainer.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import BreweryData
import BreweryPresentation

public final class BreweryDIContainer: DIContainer {

    public init() {}

    public func makeBreweryCoordinator(navigationController: UINavigationController) -> BreweryCoordinator {
        return BreweryCoordinator(navigationController: navigationController, DIContainer: self)
    }

    public func makeBreweryRepository() -> BreweryRepositoryInterface {
        return BreweryRepository()
    }

    public func makeBreweryListViewModel() -> BreweryListViewModel {
        return BreweryListViewModel(repository: makeBreweryRepository())
    }

    public func makeBreweryListViewController() -> BreweryListViewController {
        return BreweryListViewController(viewModel: makeBreweryListViewModel())
    }

    public func makeBreweryDetailViewModel(name: String) -> BreweryDetailViewModel {
        return BreweryDetailViewModel(name: name, repository: makeBreweryRepository())
    }

    public func makeBreweryDetailViewController(name: String) -> BreweryDetailBaseViewController {
        return BreweryDetailBaseViewController(viewModel: makeBreweryDetailViewModel(name: name))
    }
}
