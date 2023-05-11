//
//  LiquorRepository.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import Network
import LiquorDomain

final class LiquorRepository: LiquorRepositoryInterface {

    private let firebaseRepository: FirebaseRepositoryInterface

    init(firebaseRepository: FirebaseRepositoryInterface = FirebaseRepository.shared) {
        self.firebaseRepository = firebaseRepository
    }

    func fetchLiquors(type: LiquorType?, keyword: Keyword?) async throws -> [Liquor] {
        var query = FirebaseQuery(filters: [:], orderKey: .byHits, pageCapacity: 10)
        if let type = type {
            query.filters.updateValue(String(type.rawValue), forKey: .byCategory)
        }
        if let keyword = keyword {
            query.filters.updateValue(String(keyword.rawValue), forKey: .byKeyword)
        }

        return try await firebaseRepository.fetchLiquors(query: query, pagination: true).map { Liquor(data: $0) }
    }

    func fetchLiquorCount(type: LiquorType?, keyword: Keyword?) async throws -> Int {
        var query = FirebaseQuery(filters: [:], orderKey: .byHits, pageCapacity: 10)
        if let type = type {
            query.filters.updateValue(String(type.rawValue), forKey: .byCategory)
        }
        if let keyword = keyword {
            query.filters.updateValue(String(keyword.rawValue), forKey: .byKeyword)
        }

        return try await firebaseRepository.fetchLiquorCount(query: query)
    }

    func fetchKeywords() async throws -> [Keyword] {
        return try await firebaseRepository.fetchKeywords().map { Keyword.toDomain(data: $0) }
    }

    func fetchLiquor(name: String) async throws -> Liquor {
        let query = FirebaseQuery(filters: [.byName: name], pageCapacity: 1)
        return try await firebaseRepository.fetchLiquors(query: query, pagination: false)
            .map { Liquor(data: $0) }
            .first ?? Liquor(data: [:])
    }

    func resetPagination() {
        firebaseRepository.resetPagination()
    }
}
