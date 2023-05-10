//
//  AppCoordinator.swift
//  App
//
//  Created by 천수현 on 2023/05/09.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Home
import Liquor
import Brewery
import Watch

final class AppCoordinator {

    private let tabBarController = UITabBarController()
    private let homeNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let image = DesignAsset.Images.home.image.withRenderingMode(.alwaysTemplate)
        let selectedImage = image.withTintColor(DesignAsset.Colors.gray4.color)
        navigationController.tabBarItem = .init(title: "Home",
                                                image: image,
                                                selectedImage: selectedImage)
        return navigationController
    }()
    private let liquorNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let image = DesignAsset.Images.liquor.image.withRenderingMode(.alwaysTemplate)
        let selectedImage = image.withTintColor(DesignAsset.Colors.gray4.color)
        navigationController.tabBarItem = .init(title: "Liquor",
                                                image: image,
                                                selectedImage: selectedImage)
        return navigationController
    }()
    private let breweryNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let image = DesignAsset.Images.brewery.image.withRenderingMode(.alwaysTemplate)
        let selectedImage = image.withTintColor(DesignAsset.Colors.gray4.color)
        navigationController.tabBarItem = .init(title: "Brewery",
                                                image: image,
                                                selectedImage: selectedImage)
        return navigationController
    }()
    private let watchNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let image = DesignAsset.Images.watch.image.withRenderingMode(.alwaysTemplate)
        let selectedImage = image.withTintColor(DesignAsset.Colors.gray4.color)
        navigationController.tabBarItem = .init(title: "Watch",
                                                image: image,
                                                selectedImage: selectedImage)
        return navigationController
    }()

    init() {
        setUpTabBarController()
    }

    private func setUpTabBarController() {
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = DesignAsset.Colors.gray4.color
        [homeNavigationController, liquorNavigationController, breweryNavigationController, watchNavigationController].forEach {
            tabBarController.addChild($0)
        }
        tabBarController.tabBarItem.imageInsets = .init(top: 100, left: 0, bottom: 0, right: 0)
    }

    func start() {
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = tabBarController
        startHome()
        startLiquor()
        startBrewery()
        startWatch()
    }

    func startHome() {
        let homeDIContainer = HomeDIContainer()
        let homeCoordinator = homeDIContainer.makeHomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.start()
    }

    func startBrewery() {
        let breweryDIContainer = BreweryDIContainer()
        let breweryCoordinator = breweryDIContainer.makeBreweryCoordinator(navigationController: breweryNavigationController)
        breweryCoordinator.start()
    }

    func startLiquor() {
        let liquorDIContainer = LiquorDIContainer()
        let liquorCoordinator = LiquorCoordinator(DIContainer: liquorDIContainer, navigationController: liquorNavigationController)
        liquorCoordinator.start()
    }

    func startWatch() {
        let watchDIContainer = WatchDIContainer()
        let watchCoordinator = WatchCoordinator(DIContainer: watchDIContainer, navigationController: watchNavigationController)
        watchCoordinator.start()
    }
}
