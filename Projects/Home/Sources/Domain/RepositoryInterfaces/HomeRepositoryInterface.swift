//
//  HomeRepositoryInterface.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BaseDomain

public protocol HomeRepositoryInterface {
    func fetchViewTop10Liquors() async throws -> [Liquor]
    func fetchBuyTop10Liquors() async throws -> [Liquor]
    func fetchRecommendLists() async throws -> [Liquor]
}
