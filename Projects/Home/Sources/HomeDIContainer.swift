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

public final class HomeDIContainer: DIContainer {

    public init() {}
    
    public func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        return HomeCoordinator(navigationController: navigationController, DIContainer: self)
    }

    public func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    public func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: HomeRepository())
    }

    public func makeRecommendViewController() -> RecommendViewController {
        return RecommendViewController(viewModel: makeRecommendViewModel())
    }

    public func makeRecommendViewModel() -> RecommendViewModel {
        return RecommendViewModel(repository: HomeRepository())
    }
}
