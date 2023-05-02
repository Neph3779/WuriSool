//
//  BreweryDetailViewModel.swift
//  Brewery
//
//  Created by 천수현 on 2023/05/02.
//  Copyright © 2023 com.neph. All rights reserved.
//

import BreweryDomain
import RxSwift
import RxCocoa

final class BreweryDetailViewModel {

    private let repository: BreweryRepositoryInterface
    let selectedTab = PublishRelay<BreweryDetailBaseViewController.TabBarCategory>()

    init(repository: BreweryRepositoryInterface) {
        self.repository = repository
    }
}
