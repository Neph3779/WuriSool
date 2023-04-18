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
//import BaseDomain

final class HomeDIContainer {
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }

    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: HomeRepository())
    }
}


// MARK: - MockRepositories

final class MockHomeRepository: HomeRepositoryInterface {
    func fetchViewTop10Liquors() async throws -> [Liquor] {
        return []
    }

    func fetchBuyTop10Liquors() async throws -> [Liquor] {
        return []
    }
}
