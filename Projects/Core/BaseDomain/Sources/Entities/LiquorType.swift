//
//  LiquorType.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public enum LiquorType: Int, CaseIterable {
    case rawRiceWine = 1
    case refinedRiceWine
    case fruitWine
    case distilledLiquor
    case others

    public var name: String {
        switch self {
        case .rawRiceWine:
            return "탁주"
        case .refinedRiceWine:
            return "약주·청주"
        case .fruitWine:
            return "과실주"
        case .distilledLiquor:
            return "증류주"
        case .others:
            return "기타"
        }
    }

    public static func type(name: String) -> LiquorType {
        switch name {
        case "탁주":
            return .rawRiceWine
        case "약주":
            return refinedRiceWine
        case "청주":
            return refinedRiceWine
        case "약주, 청주":
            return refinedRiceWine
        case "과실주":
            return fruitWine
        case "증류주":
            return distilledLiquor
        default:
            return others
        }
    }
}
