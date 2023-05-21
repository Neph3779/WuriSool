//
//  CardNews.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/21.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public struct CardNews: Hashable {
    public let id: Int
    public let imagePath: String

    public var link: String {
        return "https://thesool.com/front/publication/M000000066/view.do?bbsId=A000000044&publicationId=C"
        + String(format: "%09d", id)
    }

    public init(data: [String: Any]) {
        id = data["id"] as? Int ?? -1
        imagePath = data["imagePath"] as? String ?? ""
    }
}
