//
//  Brewery.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public struct Brewery: Hashable {
    public let id: Int
    public let address: String
    public let homePage: String
    public let name: String
    public let phoneNumber: String
    public let products: [LiquorOverview]
    public let programs: [Program]
    public let types: [LiquorType]
    public let imagePath: String
    public let hits: Int
    public let mostRecentView: Date

    public init(data: [String: Any]) {
        id = data["id"] as? Int ?? -1
        address = data["address"] as? String ?? ""
        homePage = data["homePage"] as? String ?? ""
        name = data["name"] as? String ?? ""
        phoneNumber = data["phoneNumber"] as? String ?? ""
        products = ((data["products"] as? NSArray) as? [[String: Any]])?.compactMap {
            LiquorOverview(data: $0)
        } ?? []
        programs = ((data["programs"] as? NSArray) as? [[String: Any]])?.compactMap {
            Program(data: $0)
        } ?? []
        types = (data["types"] as? [Int])?.compactMap {
            LiquorType(rawValue: $0)
        } ?? []
        imagePath = data["imagePath"] as? String ?? ""
        hits = data["hits"] as? Int ?? -1
        mostRecentView = data["mostRecentView"] as? Date ?? Date()
    }
}

public struct Program: Hashable {
    public let breweryId: Int
    public let cost: String
    public let description: String
    public let name: String
    public let place: String
    public let time: String
    public let imagePath: String

    public init(data: [String: Any]) {
        breweryId = data["breweryId"] as? Int ?? -1
        cost = data["cost"] as? String ?? "cost"
        description = data["description"] as? String ?? "description"
        name = data["name"] as? String ?? "name"
        place = data["place"] as? String ?? "place"
        time = data["time"] as? String ?? "time"
        imagePath = data["imagePath"] as? String ?? "imagePath"
    }
}

public struct LiquorOverview: Hashable {
    public let liquorId: Int
    public let name: String
    public let imagePath: String
    public let dosage: String
    public let alcoholPercentage: String

    public init(data: [String: Any]) {
        liquorId = data["liquorId"] as? Int ?? -1
        name = data["liquorName"] as? String ?? "name"
        imagePath = data["imagePath"] as? String ?? "imagePath"
        dosage = data["liquorDosage"] as? String ?? "dosage"
        alcoholPercentage = data["alcoholPercentage"] as? String ?? "alcoholPercentage"
    }
}

public enum Region: CaseIterable {
    case gyeonggi
    case chungCheong
    case jeolla
    case gangWon
    case gyeongSang
    case jeju

    public var name: String {
        switch self {
        case .gyeonggi:
            return "경기도"
        case .chungCheong:
            return "충청도"
        case .jeolla:
            return "전라도"
        case .gangWon:
            return "강원도"
        case .gyeongSang:
            return "경상도"
        case .jeju:
            return "제주도"
        }
    }
}
