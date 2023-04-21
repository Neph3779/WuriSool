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
            fetchLiquorCount()
            fetchLiquors()
        }
    }
    var selectedKeyword: Keyword? {
        didSet {
            liquors.removeAll()
            fetchLiquorCount()
            fetchLiquors()
        }
    }
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

    func fetchLiquorCount() {
        Task {
            do {
                let data = try await repository.fetchLiquorCount(type: selectedType, keyword: selectedKeyword)
                updateLiquorCount?(data)
            } catch {

            }
        }
    }

    func keywordDidTapped(indexPath: IndexPath) {
        selectedKeyword = keywords[indexPath.row]
    }

    func fetchKeywords() {
        keywords = Keyword.allCases
        applyDataSource?(.keywords(keywords))
    }
}

// MARK: - View Life Cycle

extension LiquorListViewModel {
    func viewDidLoad() {
        fetchLiquors()
        fetchLiquorCount()
        fetchKeywords()
    }
}
