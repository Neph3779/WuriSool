//
//  HomeCoordinator.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import HomeDomain

final class HomeCoordinator: HomeCoordinatorInterface {
    private let navigationController: UINavigationController
    private let DIContainer: HomeDIContainer

    init(navigationController: UINavigationController, DIContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
    }
    
    func start() {
        let homeViewController = DIContainer.makeHomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }

    func liquorTapped(liquorName: String) {

    }

    func keywordTapped(keyword: Keyword) {
        
    }
}
