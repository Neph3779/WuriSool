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

    init(firebaseRepository: FirebaseRepositoryInterface = FirebaseRepository()) {
        self.firebaseRepository = firebaseRepository
    }

    func fetchKeywords() async throws -> [Keyword] {
        return []
    }

    func fetchLiquors(type: LiquorType?, keyword: Keyword?) async throws -> [Liquor] {
        var query = FirebaseQuery(filters: [:], orderKey: .byHits, pageCapacity: 10)
        if let type = type {
            query.filters.updateValue(String(type.rawValue), forKey: .byCategory)
        }
        if let keyword = keyword {
            query.filters.updateValue(String(keyword.rawValue), forKey: .byKeyword)
        }
        do {
            let data = try await firebaseRepository.fetchLiquors(
                query: query,
                pagination: true
            )
            return data.map { Liquor(data: $0) }
        } catch {
            throw error
        }
    }

    func fetchLiquorCount(type: LiquorType?, keyword: Keyword?) async throws -> Int {
        var query = FirebaseQuery(filters: [:], orderKey: .byHits, pageCapacity: 10)
        if let type = type {
            query.filters.updateValue(String(type.rawValue), forKey: .byCategory)
        }
        if let keyword = keyword {
            query.filters.updateValue(String(keyword.rawValue), forKey: .byKeyword)
        }
        do {
            let data = try await firebaseRepository.fetchLiquorCount(query: query)
            return data
        } catch {
            throw error
        }
    }
}
