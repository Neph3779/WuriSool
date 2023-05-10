//
//  LiquorCoordinator.swift
//  Liquor
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BaseDomain
import AppCoordinator

public final class LiquorCoordinator: Coordinator, LiquorCoordinatorInterface {

    public var appCoordinator: AppCoordinatorInterface?
    public let DIContainer: LiquorDIContainer
    private let navigationController: UINavigationController

    public init(DIContainer: LiquorDIContainer, navigationController: UINavigationController) {
        self.DIContainer = DIContainer
        self.navigationController = navigationController
    }

    public func start() {
        let liquorViewController = DIContainer.makeLiquorViewController()
        liquorViewController.coordinator = self
        navigationController.pushViewController(liquorViewController, animated: true)
    }

    public func start(keyword: Keyword) {
        let liquorViewController = DIContainer.makeLiquorViewController(keyword: keyword)
        liquorViewController.coordinator = self
        navigationController.pushViewController(liquorViewController, animated: true)
    }

    public func liquorItemSelected(itemName: String) {
        let liquorDetailViewController = DIContainer.makeLiquorDetailViewController(liquorName: itemName)
        liquorDetailViewController.coordinator = self
        navigationController.pushViewController(liquorDetailViewController, animated: true)
    }

    public func breweryTapped(breweryName: String) {

    }

    public func keywordTapped(keyword: Keyword) {

    }
}
