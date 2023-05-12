//
//  Coordinator.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BreweryDomain
import AppCoordinator

public final class BreweryCoordinator: Coordinator, BreweryCoordinatorInterface {

    public var appCoordinator: AppBreweryCoordinatorInterface?
    private let navigationController: UINavigationController
    public let DIContainer: BreweryDIContainer

    public init(navigationController: UINavigationController, DIContainer: BreweryDIContainer) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
    }

    public func start() {
        let listViewController = DIContainer.makeBreweryListViewController()
        listViewController.coordinator = self
        navigationController.pushViewController(listViewController, animated: true)
    }

    public func listCellSelected(breweryName: String) {
        let detailViewController = DIContainer.makeBreweryDetailViewController(name: breweryName)
        detailViewController.coordinator = self
        navigationController.pushViewController(detailViewController, animated: true)
    }

    public func visitGuideTapped(breweryId: Int) {
        
    }

    public func liquorTapped(liquorName: String) {
        appCoordinator?.pushLiquorViewToBreweryTab(liquorName: liquorName)
    }
}
