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
    func fetchLiquors(filters: [FirebaseRepository.LiquorFilterKey: Any], order: FirebaseRepository.LiquorOrderKey, pageCapacity: Int, lastSnapShot: QuerySnapshot?) async throws -> [[String: Any]]
    func fetchBrewery(filters: [FirebaseRepository.BreweryFilterKey: Any], page: Int, pageCapacity: Int) async throws -> [[String: Any]]
}

// MARK: - Main
public final class FirebaseRepository: FirebaseRepositoryInterface {
    private let logId = UUID()
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

    public func fetchLiquors(filters: [LiquorFilterKey: Any], order: LiquorOrderKey, pageCapacity: Int = 10, lastSnapShot: QuerySnapshot? = nil) async throws -> [[String: Any]] {

        var filters = filters
        var finalQuery: Query = liquorReference.order(by: order.name, descending: true)
            .limit(to: pageCapacity)

        while let filter = filters.popFirst() {
            if filter.key == .byKeyword {
                finalQuery = finalQuery.whereField(filter.key.name, arrayContains: filter.value)
            } else {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
            }
        }

        if let lastDocumentSnapshot = lastSnapShot?.documents.last {
            finalQuery.start(afterDocument: lastDocumentSnapshot)
        }

        return try await withCheckedThrowingContinuation { continuation in
            finalQuery.getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                if let snapshot = snapshot {
                    self?.logger.debug("✅ Liquors fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                } else {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                    continuation.resume(throwing: FirebaseError.noData)
                }
            }
        }
    }

    public func fetchBrewery(filters: [BreweryFilterKey: Any], page: Int = 0, pageCapacity: Int = 10) async throws -> [[String: Any]] {
        var filters = filters
        var finalQuery: Query = breweryReference.order(by: "id")
            .start(at: [page * pageCapacity])
            .limit(to: pageCapacity)

        while let filter = filters.popFirst() {
            finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
        }

        return try await withCheckedThrowingContinuation { continuation in
            finalQuery.getDocuments { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                if let snapshot = snapshot {
                    self?.logger.debug("✅ Breweries fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                } else {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                    continuation.resume(throwing: FirebaseError.noData)
                }
            }
        }
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
                return "purchaseConversion"
            }
        }
    }

    public enum BreweryFilterKey {
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

public extension FirebaseRepository {
    enum FirebaseError: Error {
        case noData
    }
}
