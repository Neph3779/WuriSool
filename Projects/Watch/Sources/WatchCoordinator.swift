//
//  WatchCoordinator.swift
//  Watch
//
//  Created by 천수현 on 2023/05/10.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import WatchDomain

public final class WatchCoordinator: Coordinator, WatchCoordinatorInterface {

    public let DIContainer: WatchDIContainer
    private let navigationController: UINavigationController

    public init(DIContainer: WatchDIContainer, navigationController: UINavigationController) {
        self.DIContainer = DIContainer
        self.navigationController = navigationController
    }

    public func start() {
        let watchViewController = DIContainer.makeWatchViewController()
        watchViewController.coordinator = self
        navigationController.pushViewController(watchViewController, animated: true)
    }
}
