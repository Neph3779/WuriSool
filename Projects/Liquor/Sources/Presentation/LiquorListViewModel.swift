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
    var keywords = [Keyword]()
    var selectedType: LiquorType? {
        didSet {
            liquors = []
            fetchLiquors()
        }
    }
    var selectedKeyword: Keyword? {
        didSet {
            liquors.removeAll()
            fetchLiquors()
        }
    }
    var isUpdating: Bool = false
    var liquorFetchTask: Task<(), Never>?


    var applyDataSource: ((LiquorListViewController.LiquorListSection) -> Void)?
    var updateLiquorCount: ((Int) -> Void)?

    init(repository: LiquorRepositoryInterface) {
        self.repository = repository
    }

    func fetchLiquors() {
        guard !isUpdating else { return }
        liquorFetchTask?.cancel()
        isUpdating = true
        liquorFetchTask = Task {
            do {
                let liquorCount = try await repository.fetchLiquorCount(type: selectedType, keyword: selectedKeyword)
                updateLiquorCount?(liquorCount)

                let fetched = try await repository.fetchLiquors(type: selectedType, keyword: selectedKeyword)
                liquors.append(contentsOf: fetched.filter {
                    !liquors.map { $0.id }.contains($0.id)
                })

                applyDataSource?(.liquors(liquors))
                isUpdating = false
            } catch {

            }
        }
    }

    func keywordDidTapped(indexPath: IndexPath) {
        selectedKeyword = keywords[indexPath.row]
    }

    func fetchKeywords() {
        Task {
            do {
                keywords = try await repository.fetchKeywords()
                applyDataSource?(.keywords(keywords))
            } catch {

            }
        }
    }
}

// MARK: - View Life Cycle

extension LiquorListViewModel {
    func viewDidLoad() {
        fetchLiquors()
        fetchKeywords()
    }
}
