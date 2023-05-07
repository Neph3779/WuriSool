//
//  BreweryRepository.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BreweryDomain

final class BreweryRepository: BreweryRepositoryInterface {
    private let firebaseRepository: FirebaseRepositoryInterface

    init(firebaseRepository: FirebaseRepositoryInterface = FirebaseRepository.shared) {
        self.firebaseRepository = firebaseRepository
    }

    func fetchBrewerys(region: String) async throws -> [Brewery] {
        let query = FirebaseQuery(filters: [.byRegion: region], pageCapacity: 10)
        return try await firebaseRepository.fetchBrewery(query: query, pagination: true).map { Brewery(data: $0) }
    }

    func fetchBrewery(name: String) async throws -> Brewery {
        let query = FirebaseQuery(filters: [.byName: name], pageCapacity: 1)
        let data = try await firebaseRepository.fetchBrewery(query: query, pagination: false)
        return Brewery(data: data.first ?? [:])
    }
}
