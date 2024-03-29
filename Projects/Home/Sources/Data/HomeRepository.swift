//
//  HomeRepository.swift
//  HomeData
//
//  Created by 천수현 on 2023/04/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import Network
import HomeDomain

final class HomeRepository: HomeRepositoryInterface {
    private let firebaseRepository: FirebaseRepositoryInterface

    init(firebaseRepository: FirebaseRepositoryInterface = FirebaseRepository.shared) {
        self.firebaseRepository = firebaseRepository
    }

    func fetchViewTop10Liquors() async throws -> [Liquor] {
        do {
            let data = try await firebaseRepository.fetchLiquors(query: FirebaseQuery(filters: [:], orderKey: .byHits, pageCapacity: 10), pagination: true)
            return data.map { Liquor(data: $0) }
        } catch {
            throw error
        }
    }

    func fetchBuyTop10Liquors() async throws -> [Liquor] {
        do {
            let data = try await firebaseRepository.fetchLiquors(query: FirebaseQuery(filters: [:], orderKey: .byPopularity, pageCapacity: 10), pagination: true)
            return data.map { Liquor(data: $0) }
        } catch {
            throw error
        }
    }

    func fetchViewTop10Keywords() async throws -> [Keyword] {
        return []
    }

    func fetchRecommendLists() async throws -> [Liquor] {
        return try await firebaseRepository.fetchRecommendLiquors().map { Liquor(data: $0) }
    }
}
