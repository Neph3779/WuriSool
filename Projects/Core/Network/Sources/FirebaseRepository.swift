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
    func fetchLiquorCount(query: FirebaseQuery) async throws -> Int
    func fetchKeywords() async throws -> [[String: Any]]
    func resetPagination()
    func updateLiquorAssociation(liquorId: Int) async throws
    func fetchRecommendLiquors() async throws -> [[String: Any]]
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

    public static let shared = FirebaseRepository()

    private let logId = UUID()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: "FirebaseRepository")
    private let database: Firestore
    private lazy var liquorReference = database.collection("Liquor")
    private lazy var breweryReference = database.collection("Brewery")
    private lazy var keywordReference = database.collection("Keyword")
    private lazy var liquorAssociationReference = database.collection("Association")
    private var snapShotCache: [FirebaseQuery: QueryDocumentSnapshot?] = [:] // for support pagination

    // TODO: singleton pattern 사용하므로 init private으로 바꾸기
    public init() {
        let filePath = NetworkResources.bundle.path(forResource: "GoogleService-Info-Network", ofType: "plist")
        guard let fileOptions = FirebaseOptions(contentsOfFile: filePath!) else {
            fatalError()
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

    public func fetchLiquorCount(query: FirebaseQuery) async throws -> Int {
        var filters = query.filters
        var finalQuery: Query = liquorReference.order(by: query.orderKey?.name ?? "id", descending: true)

        while let filter = filters.popFirst() {
            if filter.key == .byKeyword {
                finalQuery = finalQuery.whereField(filter.key.name, arrayContains: Int(filter.value) ?? -1)
            } else if filter.key == .byCategory {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: Int(filter.value) ?? -1)
            } else {
                finalQuery = finalQuery.whereField(filter.key.name, isEqualTo: filter.value)
            }
        }

        let countQuery = finalQuery.count
        do {
            let snapshot = try await countQuery.getAggregation(source: .server)
            return Int(truncating: snapshot.count)
        } catch {
            throw error
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
                    self?.logger.debug("✅ Brewerys fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
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

    public func fetchKeywords() async throws -> [[String: Any]] {
        let finalQuery: Query = keywordReference.order(by: "hits")

        return try await withCheckedThrowingContinuation { continuation in
            let handler: ((QuerySnapshot?, Error?) -> Void) = { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    return
                }
                if let snapshot = snapshot {
                    self?.logger.debug("✅ Keywords fetching completed. LogId: \(self?.logId.uuidString ?? "unknown")")
                    continuation.resume(returning: snapshot.documents.map { $0.data() })
                    return
                } else {
                    self?.logger.log("🚨 file: \(#file), function: \(#function) errorMessage: There is no data in snapshot")
                    continuation.resume(throwing: FirebaseError.noData)
                    return
                }
            }
            finalQuery.getDocuments(completion: handler)
        }
    }

    public func updateLiquorAssociation(liquorId: Int) async throws {
        guard let recentViewedLiquors = UserDefaults.standard.value(forKey: "recentViewedLiquors") as? [Int] else {
            UserDefaults.standard.set([liquorId], forKey: "recentViewedLiquors")
            return
        }

        try await withThrowingTaskGroup(of: Void.self) { taskGroup in
            for id in recentViewedLiquors where id != liquorId {
                taskGroup.addTask {
                    guard let data = try await self.liquorAssociationReference.document("\(id)").getDocument().data(),
                          var association = data["association"] as? [Int] else { return }
                    association[liquorId] += 1
                    try await self.liquorAssociationReference.document("\(id)").updateData(["association": association])
                }
            }
            try await taskGroup.waitForAll()
            logger.log("✅ Liquor association update completed")
        }
    }

    public func fetchRecommendLiquors() async throws -> [[String: Any]] {
        guard let recentViewedLiquors = UserDefaults.standard.value(forKey: "recentViewedLiquors") as? [Int] else {
            throw FirebaseError.noData
        }

        let associationSum = try await withThrowingTaskGroup(of: [Int].self) { taskGroup -> [Int] in

            for id in recentViewedLiquors {
                taskGroup.addTask {
                    guard let data = try await self.liquorAssociationReference.document("\(id)").getDocument().data(),
                          let association = data["association"] as? [Int] else { return [] }
                    return association
                }
            }

            var associations = [[Int]]()

            for try await value in taskGroup {
                associations.append(value)
            }
            let associationSum: [Int] = associations.reduce(into: []) { partialResult, association in
                if partialResult.isEmpty {
                    partialResult += association
                } else {
                    for i in 0..<partialResult.count {
                        guard association.count > i else { continue }
                        partialResult[i] += association[i]
                    }
                }
            }
            logger.log("✅ Liquor association fetch completed")
            return associationSum
        }

        let recommends = associationSum.enumerated()
            .sorted {
                if $0.element == $1.element {
                   return $0.offset < $1.offset
                } else {
                    return $0.element > $1.element
                }
            }.map {
                $0.offset
            }
            .prefix(10)

        let recommendData = try await withThrowingTaskGroup(of: [String: Any].self) { taskGroup -> [[String: Any]] in

            for id in recommends {
                taskGroup.addTask {
                    guard let data = try await self.liquorReference.document("\(id)").getDocument().data() else { return [:] }
                    return data
                }
            }

            var recommendData = [[String : Any]]()

            for try await value in taskGroup {
                recommendData.append(value)
            }
            return recommendData
        }

        return recommendData
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
