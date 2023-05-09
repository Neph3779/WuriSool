//
//  Coordinator.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

final class BreweryCoordinator: BreweryCoordinatorInterface {
    private let navigationController: UINavigationController
    private let DIContainer: BreweryDIContainer

    init(navigationController: UINavigationController, DIContainer: BreweryDIContainer) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
    }

    func start() {
        let listViewController = DIContainer.makeBreweryListViewController()
        listViewController.coordinator = self
        navigationController.pushViewController(listViewController, animated: true)
    }

    func listCellSelected(breweryName: String) {
        let detailViewController = DIContainer.makeBreweryDetailViewController(name: breweryName)
        navigationController.pushViewController(detailViewController, animated: true)
    }

    func visitGuideTapped(breweryId: Int) {
        
    }

    func liquorTapped(liquorName: String) {

    }
}
