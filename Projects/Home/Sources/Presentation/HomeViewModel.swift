//
//  HomeViewModel.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import HomeDomain

public final class HomeViewModel {

    private let repository: HomeRepositoryInterface
    var viewTop10Liquors = [Liquor]()
    var buyTop10Liquors = [Liquor]()

    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

private extension HomeViewModel {
    private func fetchViewTop10Liquors() {

    }

    private func fetchBuyTop10Liquors() {

    }
}
