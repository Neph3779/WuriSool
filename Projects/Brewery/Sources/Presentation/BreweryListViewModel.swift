//
//  BreweryListViewModel.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BreweryDomain

final class BreweryListViewModel {

    private let repository: BreweryRepositoryInterface

    init(repository: BreweryRepositoryInterface) {
        self.repository = repository
    }
}
