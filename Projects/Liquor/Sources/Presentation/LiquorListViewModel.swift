//
//  LiquorListViewModel.swift
//  Liquor
//
//  Created by 천수현 on 2023/04/19.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import LiquorDomain
import RxSwift
import RxCocoa

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
    var rxSelectedType = BehaviorRelay<LiquorType?>(value: nil)
    var rxSelectedKeyword = BehaviorRelay<Keyword?>(value: nil)
    var rxLiquorCount = BehaviorSubject<Int>(value: 0)
    var isUpdating = BehaviorRelay<Bool>(value: false)
    var liquorFetchTask: Task<(), Never>?
    var applyDataSource: ((LiquorListViewController.LiquorListSection) -> Void)?
    var updateLiquorCount: ((Int) -> Void)?
    private var disposeBag = DisposeBag()

    init(repository: LiquorRepositoryInterface) {
        self.repository = repository
        Observable.combineLatest(rxSelectedType, rxSelectedKeyword)
            .subscribe(onNext: { [weak self] _, _ in
                self?.liquors.removeAll()
                self?.fetchLiquors()
            })
            .disposed(by: disposeBag)
    }

    func fetchLiquors() {
        guard !isUpdating.value else { return }
        liquorFetchTask?.cancel()
        isUpdating.accept(true)
        liquorFetchTask = Task {
            do {
                let liquorCount = try await repository.fetchLiquorCount(type: rxSelectedType.value,
                                                                        keyword: rxSelectedKeyword.value)
                updateLiquorCount?(liquorCount)

                let fetched = try await repository.fetchLiquors(type: rxSelectedType.value,
                                                                keyword: rxSelectedKeyword.value)
                liquors.append(contentsOf: fetched.filter {
                    !liquors.map { $0.id }.contains($0.id)
                })

                applyDataSource?(.liquors(liquors))
                isUpdating.accept(false)
            } catch {

            }
        }
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
