//
//  Brewery.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public struct Brewery {
    let id: Int
    let address: String
    let homePage: String
    let name: String
    let phoneNumber: String
    let products: [LiquorOverview]
    let programs: [Program]
    let types: [LiquorType]
    let imagePath: String
    let hits: Int
    let mostRecentView: Date

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
        imagePath = ""
        hits = data["hits"] as? Int ?? -1
        mostRecentView = data["mostRecentView"] as? Date ?? Date()
    }
}

public struct Program {
    let breweryId: Int
    let cost: String
    let description: String
    let name: String
    let place: String
    let time: String
    let imagePath: String

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

struct LiquorOverview {
    let liquorId: Int
    let name: String
    let imagePath: String
    let dosage: String
    let alcoholPercentage: String

    public init(data: [String: Any]) {
        liquorId = data["liquorId"] as? Int ?? -1
        name = data["name"] as? String ?? "name"
        imagePath = data["imagePath"] as? String ?? "imagePath"
        dosage = data["dosage"] as? String ?? "dosage"
        alcoholPercentage = data["alcoholPercentage"] as? String ?? "alcoholPercentage"
    }
}
