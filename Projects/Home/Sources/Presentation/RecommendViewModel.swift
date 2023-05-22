//
//  RecommendViewModel.swift
//  Home
//
//  Created by 천수현 on 2023/05/22.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BaseDomain
import Design
import HomeDomain

public final class RecommendViewModel {
    var rxLiquors = BehaviorRelay<[Liquor]>(value: [])
    var isUpdating = BehaviorRelay<Bool>(value: false)
    var liquorFetchTask: Task<(), Never>?
    private let repository: HomeRepositoryInterface

    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }

    func fetchLiquors() {
        guard !isUpdating.value else { return }
        liquorFetchTask?.cancel()
        isUpdating.accept(true)
        liquorFetchTask = Task {
            do {
                let fetched = try await repository.fetchRecommendLists()
                var liquors = rxLiquors.value

                liquors.append(contentsOf: fetched.filter {
                    !liquors.map { $0.id }.contains($0.id)
                })

                rxLiquors.accept(liquors)
                isUpdating.accept(false)
            } catch {
                print(error)
            }
        }
    }
}
