//
//  LiquorCoordinator.swift
//  Liquor
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BaseDomain

final class LiquorCoordinator: Coordinator, LiquorCoordinatorInterface {
    let DIContainer: LiquorDIContainer
    private let navigationController: UINavigationController

    init(DIContainer: LiquorDIContainer, navigationController: UINavigationController) {
        self.DIContainer = DIContainer
        self.navigationController = navigationController
    }

    func start() {
        let liquorViewController = DIContainer.makeLiquorViewController()
        liquorViewController.coordinator = self
        navigationController.pushViewController(liquorViewController, animated: true)
    }

    func liquorItemSelected(itemName: String) {
        let liquorDetailViewController = DIContainer.makeLiquorDetailViewController(liquorName: itemName)
        liquorDetailViewController.coordinator = self
        navigationController.pushViewController(liquorDetailViewController, animated: true)
    }

    func breweryTapped(breweryName: String) {

    }

    func keywordTapped(keyword: Keyword) {

    }
}
