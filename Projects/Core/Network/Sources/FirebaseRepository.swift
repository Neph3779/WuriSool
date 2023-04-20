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
    func fetchLiquors(query: FirebaseQuery, pagination: Bool) async throws -> [[String: Any]]
    func fetchBrewery(query: FirebaseQuery, pagination: Bool) async throws -> [[String: Any]]
}

public struct FirebaseQuery: Hashable {
    public var filters: [FirebaseRepository.FilterKey: String]
    public var orderKey: FirebaseRepository.OrderKey?
    public var pageCapacity: Int

    public init(filters: [FirebaseRepository.FilterKey : String], orderKey: FirebaseRepository.OrderKey? = nil, pageCapacity: Int) {
        self.filters = filters
        self.orderKey = orderKey
        self.pageCapacity = pageCapacity
    }
}

// MARK: - Main
public final class FirebaseRepository: FirebaseRepositoryInterface {
    private let logId = UUID()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: "FirebaseRepository")
    private let database: Firestore
    private lazy var liquorReference = database.collection("Liquor")
    private lazy var breweryReference = database.collection("Brewery")
    private var snapShotCache: [FirebaseQuery: QueryDocumentSnapshot?] = [:] // for support pagination

    public init() {
        let filePath = NetworkResources.bundle.path(forResource: "GoogleService-Info-Network", ofType: "plist")
        guard let fileOptions = FirebaseOptions(contentsOfFile: filePath!) else {
            assert(false, "Couldn't load config file")
        }
        FirebaseApp.configure(options: fileOptions)
        database = Firestore.firestore()
    }

    public func fetchLiquors(query: FirebaseQuery, pagination: Bool = false) async throws -> [[String: Any]] {
        var filters = query.filters
        var finalQuery: Query = liquorReference.order(by: query.orderKey?.name ?? "id", descending: true)
            .limit(to: query.pageCapacity)

        while let filter = filters.popFirst() {
            if filter.key == .byKeyword {
                finalQuery = finalQuery.whereField(filter.key.name, arrayContains: Int(filter.value) ?? -1)
            } else if filter.key == .byCategory {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: Int(filter.value) ?? -1)
            } else {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
            }
        }

        return try await withCheckedThrowingContinuation { continuation in
            let handler: ((QuerySnapshot?, Error?) -> Void) = { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                if let snapshot = snapshot {
                    self?.logger.debug("✅ Liquors fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                    if pagination {
                        self?.snapShotCache.updateValue(snapshot.documents.last, forKey: query)
                    }
                    return
                } else {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                    continuation.resume(throwing: FirebaseError.noData)
                    return
                }
            }

            if let lastSnapshot = snapShotCache[query],
               let lastSnapshot = lastSnapshot,
               pagination {
                finalQuery.start(afterDocument: lastSnapshot)
                    .getDocuments(completion: handler)
            } else {
                finalQuery.getDocuments(completion: handler)
            }
        }
    }

    public func fetchBrewery(query: FirebaseQuery, pagination: Bool) async throws -> [[String: Any]] {
        var filters = query.filters
        var finalQuery: Query = breweryReference.order(by: "id")
            .limit(to: query.pageCapacity)

        while let filter = filters.popFirst() {
            finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
        }

        return try await withCheckedThrowingContinuation { continuation in
            let handler: ((QuerySnapshot?, Error?) -> Void) = { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                if let snapshot = snapshot {
                    self?.logger.debug("✅ Liquors fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                    return
                } else {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                    continuation.resume(throwing: FirebaseError.noData)
                    return
                }
            }

            if let lastSnapshot = snapShotCache[query],
               let lastSnapshot = lastSnapshot,
               pagination {
                finalQuery.start(afterDocument: lastSnapshot)
                    .getDocuments(completion: handler)
            } else {
                finalQuery.getDocuments(completion: handler)
            }
        }
    }

    public func resetPagination() {
        snapShotCache.removeAll()
    }
}

// MARK: - FilterKey & OrderKey

extension FirebaseRepository {

    public enum FilterKey {
        case byKeyword
        case byCategory
        case byName
        case byRegion

        public var name: String {
            switch self {
            case .byKeyword:
                return "keywords"
            case .byCategory:
                return "type"
            case .byName:
                return "name"
            case .byRegion:
                return "region"
            }
        }
    }

    public enum OrderKey {
        case byHits
        case byPopularity

        public var name: String {
            switch self {
            case .byHits:
                return "hits"
            case .byPopularity:
                return "purchaseConversion"
            }
        }
    }
}

public extension FirebaseRepository {
    enum FirebaseError: Error {
        case noData
    }
}
