//
//  BreweryListViewModel.swift
//  Brewery
//
//  Created by 천수현 on 2023/04/29.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import BreweryDomain
import RxSwift
import RxCocoa

final class BreweryListViewModel {

    private let repository: BreweryRepositoryInterface
    private let region = ""
    private let disposeBag = DisposeBag()
    let selectedRegion = BehaviorRelay<String>(value: "서울, 경기")
    let brewerys = BehaviorRelay<[Brewery]>(value: [])

    init(repository: BreweryRepositoryInterface) {
        self.repository = repository
        selectedRegion
            .asDriver()
            .drive { [weak self] address in
                self?.fetchBrewery()
            }
            .disposed(by: disposeBag)
    }

    func fetchBrewery() {
        Task {
            do {
                let region = selectedRegion.value
                let data = try await repository.fetchBrewerys(region: region)
                brewerys.accept(data)
            } catch {

            }
        }
    }
}

// MARK: - View Life Cycle

extension BreweryListViewModel {
    func viewDidLoad() {
        fetchBrewery()
    }
}
