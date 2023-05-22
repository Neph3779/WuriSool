//
//  LiquorDetailViewModel.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/27.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import LiquorDomain

public final class LiquorDetailViewModel {
    let liquor = BehaviorRelay<Liquor>(value: Liquor(data: [:]))
    private let repository: LiquorRepositoryInterface

    init(name: String, liquor: Liquor? = nil, repository: LiquorRepositoryInterface) {
        self.repository = repository
        if let liquor = liquor {
            self.liquor.accept(liquor)
        } else {
            fetchLiquor(name: name)
        }
    }

    private func fetchLiquor(name: String) {
        Task {
            do {
                let data = try await repository.fetchLiquor(name: name)
                liquor.accept(data)
                updateRecentViewedLiquors(id: data.id)
                try await repository.updateLiquorAssociation(liquorId: data.id)
            } catch {

            }
        }
    }

    private func updateRecentViewedLiquors(id: Int) {
        guard var recentViewedLiquors =  UserDefaults.standard.value(forKey: "recentViewedLiquors") as? [Int] else {
            UserDefaults.standard.set([id], forKey: "recentViewedLiquors")
            return
        }
        if recentViewedLiquors.count >= 10 {
            recentViewedLiquors.removeFirst()
        }
        recentViewedLiquors.append(id)
        UserDefaults.standard.setValue(recentViewedLiquors, forKey: "recentViewedLiquors")
    }
}
