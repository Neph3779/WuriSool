//
//  AppCoordinator.swift
//  App
//
//  Created by 천수현 on 2023/05/09.
//  Copyright © 2023 com.neph. All rights reserved.
//

import UIKit
import BaseDomain

public protocol AppCoordinatorInterface {
    func pushLiquorView(liquorName: String)
    func moveToLiquorTab(with keyword: Keyword)
}

public protocol AppBreweryCoordinatorInterface {
    func pushLiquorViewToBreweryTab(liquorName: String)
}
