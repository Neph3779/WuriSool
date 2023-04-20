//
//  LiquorListViewModel.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import LiquorDomain

final class LiquorListViewModel {

    private let repository: LiquorRepositoryInterface
    var liquors = [Liquor]()
    var type: LiquorType?
    var keyword: Keyword?
    var isUpdating: Bool = false


    var applyDataSource: ((LiquorListViewController.LiquorListSection) -> Void)?
    var updateLiquorCount: ((Int) -> Void)?

    init(repository: LiquorRepositoryInterface) {
        self.repository = repository
    }

    func fetchLiquors() {
        guard !isUpdating else { return }
        isUpdating = true
        Task {
            do {
                let fetched = try await repository.fetchLiquors(type: type, keyword: keyword)
                liquors.append(contentsOf: fetched.filter { !liquors.contains($0) })
                applyDataSource?(.liquors(liquors))
                isUpdating = false
            } catch {

            }
        }
    }

    func fetchLiquorCount() {
        Task {
            do {
                let data = try await repository.fetchLiquorCount(type: type, keyword: keyword)
                updateLiquorCount?(data)
            } catch {

            }
        }
    }
}

// MARK: - View Life Cycle

extension LiquorListViewModel {
    func viewDidLoad() {
        fetchLiquors()
        fetchLiquorCount()
    }
}
