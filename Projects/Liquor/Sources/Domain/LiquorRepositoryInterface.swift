//
//  LiquorRepositoryInterface.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public protocol LiquorRepositoryInterface {
    func fetchKeywords() async throws -> [Keyword]
    func fetchLiquors(type: LiquorType?, keyword: Keyword?) async throws -> [Liquor]
    func fetchLiquorCount(type: LiquorType?, keyword: Keyword?) async throws -> Int
    func fetchLiquor(name: String) async throws -> Liquor
    func resetPagination()
}
