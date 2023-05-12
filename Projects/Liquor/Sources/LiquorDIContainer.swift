//
//  DIContainer.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import LiquorDomain
import LiquorPresentation
import LiquorData

public final class LiquorDIContainer: DIContainer {

    public init() {}
    
    public func makeLiquorCoordinator(navigationController: UINavigationController) -> LiquorCoordinator {
        return LiquorCoordinator(DIContainer: self, navigationController: navigationController)
    }

    func makeLiquorRepository() -> LiquorRepositoryInterface {
        return LiquorRepository()
    }

    func makeLiquorViewModel(mode: LiquorListViewModel.Mode) -> LiquorListViewModel {
        return LiquorListViewModel(repository: makeLiquorRepository(), mode: mode)
    }

    public func makeLiquorViewController(mode: LiquorListViewModel.Mode) -> LiquorListViewController {
        return LiquorListViewController(viewModel: makeLiquorViewModel(mode: mode))
    }

    func makeLiquorDetailViewModel(liquorName: String) -> LiquorDetailViewModel {
        return LiquorDetailViewModel(name: liquorName, repository: makeLiquorRepository())
    }

    public func makeLiquorDetailViewController(liquorName: String) -> LiquorDetailViewController {
        return LiquorDetailViewController(viewModel: makeLiquorDetailViewModel(liquorName: liquorName))
    }
}
