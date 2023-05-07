//
//  BreweryCoordinatorInterface.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/07.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public protocol BreweryCoordinatorInterface {
    func start()
    func listCellSelected(breweryName: String)
}
