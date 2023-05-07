//
//  HomeDIContainer.swift
//  HomeData
//
//  Created by 천수현 on 2023/04/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import HomePresentation
import HomeData
import HomeDomain

final class HomeDIContainer {
    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, DIContainer: self)
    }

    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: HomeRepository())
    }
}
