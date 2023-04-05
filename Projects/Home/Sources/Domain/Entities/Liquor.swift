//
//  Liquor.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public struct Liquor {
    let id: Int
    let alcoholPercentage: String
    let dosage: String
    let name: String
    let imagePath: String

    public init(data: [String: Any]) {
        id = data["id"] as? Int ?? -1
        alcoholPercentage = data["alcoholPercentage"] as? String ?? ""
        dosage = data["dosage"] as? String ?? ""
        name = data["name"] as? String ?? ""
        imagePath = data["imagePath"] as? String ?? ""
    }
}
