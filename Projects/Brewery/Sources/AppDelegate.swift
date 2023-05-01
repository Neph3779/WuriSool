//
//  AppDelegate.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let DIContainer = DIContainer()
        window = UIWindow(frame: UIScreen.main.bounds)
//        let viewController = DIContainer.makeBreweryListViewController()
        let viewController = BreweryDetailBaseViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
