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

public final class BreweryDetailViewModel {

    private let repository: BreweryRepositoryInterface
    let selectedTab = PublishRelay<BreweryDetailBaseViewController.TabBarCategory>()
    let brewery = BehaviorRelay<Brewery>(value: Brewery(data: [:]))

    init(name: String, brewery: Brewery? = nil, repository: BreweryRepositoryInterface) {
        self.repository = repository
        if let brewery = brewery {
            self.brewery.accept(brewery)
        } else {
            fetchBrewery(name: name)
        }
    }

    func fetchBrewery(name: String) {
        Task {
            do {
                let data = try await repository.fetchBrewery(name: name)
                brewery.accept(data)
            } catch {

            }
        }
    }
}
