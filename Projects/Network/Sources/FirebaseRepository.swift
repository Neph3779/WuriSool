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
    func fetchLiquors(filters: [FirebaseRepository.LiquorFilterKey: Any], order: FirebaseRepository.LiquorOrderKey, page: Int, pageCapacity: Int) async throws -> [[String: Any]]
    func fetchBrewery(by querys: [FirebaseRepository.BrewerySortingKey: Any], page: Int, pageCapacity: Int) async throws -> [[String: Any]]
}

// MARK: - Main
public final class FirebaseRepository: FirebaseRepositoryInterface {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: "FirebaseRepository")
    private let database: Firestore
    private lazy var liquorReference = database.collection("Liquor")
    private lazy var breweryReference = database.collection("Brewery")

    public init() {
        let filePath = NetworkResources.bundle.path(forResource: "GoogleService-Info-Network", ofType: "plist")
        guard let fileOptions = FirebaseOptions(contentsOfFile: filePath!) else {
            assert(false, "Couldn't load config file")
        }
        FirebaseApp.configure(options: fileOptions)
        database = Firestore.firestore()
    }

    public func fetchLiquors(filters: [LiquorFilterKey: Any], order: LiquorOrderKey, page: Int = 0, pageCapacity: Int = 10) async throws -> [[String: Any]] {
        var filters = filters
        var finalQuery: Query = liquorReference.order(by: order.name)
            .start(at: [page * pageCapacity])
            .limit(to: pageCapacity)

        while let filter = filters.popFirst() {
            if filter.key == .byKeyword {
                finalQuery = finalQuery.whereField(filter.key.name, arrayContains: filter.value)
            } else {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            finalQuery.getDocuments { [weak self] snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    self?.logger.debug("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                }
                if let snapshot = snapshot {
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                } else {
                    self?.logger.debug("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                }
            }
        }
    }

    public func fetchBrewery(by querys: [BrewerySortingKey: Any], page: Int = 0, pageCapacity: Int = 10) async throws -> [[String: Any]] {
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

    public enum LiquorFilterKey {
        case byKeyword
        case byCategory
        case byName

        var name: String {
            switch self {
            case .byKeyword:
                return "keywords"
            case .byCategory:
                return "type"
            case .byName:
                return "name"
            }
        }
    }

    public enum LiquorOrderKey {
        case byHits
        case byPopularity

        var name: String {
            switch self {
            case .byHits:
                return "hits"
            case .byPopularity:
                return "purchaseCount"
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
