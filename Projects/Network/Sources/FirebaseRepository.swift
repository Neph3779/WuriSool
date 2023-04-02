//
//  FirebaseRepository.swift
//  Network
//
//  Created by 천수현 on 2023/04/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import OSLog

// MARK: - Interface
public protocol FirebaseRepositoryInterface {
    func fetchLiquors(by querys: [FirebaseRepository.LiquorSortingKey: Any], page: Int, pageCapacity: Int) -> [[String: Any]]
    func fetchBrewery(by querys: [FirebaseRepository.BrewerySortingKey: Any], page: Int, pageCapacity: Int) -> [[String: Any]]
}

// MARK: - Main
public final class FirebaseRepository: FirebaseRepositoryInterface {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: "FirebaseRepository")
    private let database = Firestore.firestore()
    private lazy var liquorReference = database.collection("Liquor")
    private lazy var breweryReference = database.collection("Brewery")

    public func fetchLiquors(by querys: [LiquorSortingKey: Any], page: Int = 0, pageCapacity: Int = 10) -> [[String: Any]] {
        return []
    }

    public func fetchBrewery(by querys: [BrewerySortingKey: Any], page: Int = 0, pageCapacity: Int = 10) -> [[String: Any]] {
        return []
    }
}

// MARK: - Search Target & Sorting Keys
extension FirebaseRepository {
    enum SearchTarget {
        case liquor
        case brewery
        case cardNews
    }

    public enum LiquorSortingKey {
        case byHits
        case byPopularity
        case byKeyword
        case byCategory
        case byName

        var name: String {
            switch self {
            case .byHits:
                return "hits"
            case .byPopularity:
                return "purchaseCount"
            case .byKeyword:
                return "keywords"
            case .byCategory:
                return "type"
            case .byName:
                return "name"
            }
        }
    }

    public enum BrewerySortingKey {
        case byRegion
        case byName

        var name: String {
            switch self {
            case .byRegion:
                return "region"
            case .byName:
                return "name"
            }
        }
    }
}
