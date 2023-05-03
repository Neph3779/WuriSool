//
//  BreweryRepositoryInterface.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

public protocol BreweryRepositoryInterface {
    func fetchBrewerys(region: String) async throws -> [Brewery]
    func fetchBrewery(name: String) async throws -> Brewery
}
