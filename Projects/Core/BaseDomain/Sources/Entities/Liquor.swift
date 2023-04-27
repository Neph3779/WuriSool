//
//  Liquor.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public struct Liquor: Hashable {
    public static func == (lhs: Liquor, rhs: Liquor) -> Bool {
        return lhs.id == rhs.id
    }

    public let id: Int
    public let alcoholPercentage: String
    public let description: String
    public let dosage: String
    public let foods: String
    public let ingredients: String
    public let keywords: [Keyword]
    public let name: String
    public let type: LiquorType
    public let brewery: BreweryOverview
    public let award: String
    public let other: String
    public let imagePath: String
    public let hits: Int
    public let purchaseConversion: Int

    public init(data: [String: Any]) {
        id = data["id"] as? Int ?? -1
        alcoholPercentage = data["alcoholPercentage"] as? String ?? ""
        description = data["description"] as? String ?? ""
        dosage = data["dosage"] as? String ?? ""
        foods = data["foods"] as? String ?? ""
        name = data["name"] as? String ?? ""
        imagePath = data["imagePath"] as? String ?? ""
        ingredients = data["ingredients"] as? String ?? ""
        award = data["award"] as? String ?? ""
        other = data["other"] as? String ?? ""
        hits = data["hits"] as? Int ?? -1
        purchaseConversion = data["purchaseConversion"] as? Int ?? -1
        keywords = (data["keywords"] as? [Int])?.compactMap {
            Keyword(rawValue: $0)
        } ?? []
        type = LiquorType(rawValue: data["type"] as? Int ?? -1) ?? .others
        brewery = BreweryOverview(data: data["brewery"] as? [String: Any] ?? [:])
    }
}

public struct BreweryOverview: Hashable {
    public let breweryId: Int
    public let name: String
    public let address: String
    public let homePage: String
    public let phoneNumber: String

    public init(data: [String: Any]) {
        breweryId = data["breweryId"] as? Int ?? -1
        name = data["breweryName"] as? String ?? ""
        address = data["breweryAddress"] as? String ?? ""
        homePage = data["brewryHomePage"] as? String ?? ""
        phoneNumber = data["breweryPhoneNumber"] as? String ?? ""
    }
}
