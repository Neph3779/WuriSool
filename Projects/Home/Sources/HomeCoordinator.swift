//
//  HomeCoordinator.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import HomeDomain

public final class HomeCoordinator: Coordinator, HomeCoordinatorInterface {
    private let navigationController: UINavigationController
    public let DIContainer: HomeDIContainer

    public init(navigationController: UINavigationController, DIContainer: HomeDIContainer) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
    }

    public func start() {
        let homeViewController = DIContainer.makeHomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }

    public func liquorTapped(liquorName: String) {

    }

    public func keywordTapped(keyword: Keyword) {
        
    }
}
