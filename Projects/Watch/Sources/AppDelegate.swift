//
//  AppDelegate.swift
//  App
//
//  Created by 천수현 on 2023/04/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import Network

@main class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let DIContainer = WatchDIContainer()
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = DIContainer.makeWatchViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
