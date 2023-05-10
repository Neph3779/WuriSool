//
//  HomeCoordinator.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import HomeDomain
import AppCoordinator

public final class HomeCoordinator: Coordinator, HomeCoordinatorInterface {

    public var appCoordinator: AppCoordinatorInterface?
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
        appCoordinator?.pushLiquorView(liquorName: liquorName)
    }

    public func keywordTapped(keyword: Keyword) {
        appCoordinator?.moveToLiquorTab(with: keyword)
    }
}
