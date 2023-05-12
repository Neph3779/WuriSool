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

public final class LiquorListViewModel {
    public enum Mode: Equatable {
        case search
        case keyword(Keyword)
    }
    let mode: Mode
    var rxLiquors = BehaviorRelay<[Liquor]>(value: [])
    var rxKeywords = BehaviorRelay<[Keyword]>(value: [])
    var rxSelectedType = BehaviorRelay<LiquorType?>(value: nil)
    var rxSelectedKeyword = BehaviorRelay<Keyword?>(value: nil)
    var rxLiquorCount = BehaviorSubject<Int>(value: 0)
    var isUpdating = BehaviorRelay<Bool>(value: false)
    var liquorFetchTask: Task<(), Never>?

    private let disposeBag = DisposeBag()
    private let repository: LiquorRepositoryInterface
    private var selectedKeyword: Keyword?

    init(repository: LiquorRepositoryInterface, mode: Mode) {
        self.mode = mode
        self.repository = repository

        if case .keyword(let keyword) = mode {
            rxSelectedKeyword.accept(keyword)
        }
    }

    func fetchLiquors() {
        guard !isUpdating.value else { return }
        liquorFetchTask?.cancel()
        isUpdating.accept(true)
        liquorFetchTask = Task {
            do {
                let liquorCount = try await repository.fetchLiquorCount(type: rxSelectedType.value,
                                                                        keyword: rxSelectedKeyword.value)
                rxLiquorCount.onNext(liquorCount)

                let fetched = try await repository.fetchLiquors(type: rxSelectedType.value,
                                                                keyword: rxSelectedKeyword.value)
                var liquors = rxLiquors.value

                liquors.append(contentsOf: fetched.filter {
                    !liquors.map { $0.id }.contains($0.id)
                })

                rxLiquors.accept(liquors)
                isUpdating.accept(false)
            } catch {

            }
        }
    }

    func fetchKeywords() {
        Task {
            do {
                let keywords = try await repository.fetchKeywords()
                rxKeywords.accept(keywords)
                if let selectedKeyword = selectedKeyword {
                    rxLiquors.accept([])
                    rxSelectedKeyword.accept(selectedKeyword)
                }
            } catch {

            }
        }
    }
}

// MARK: - View Life Cycle

extension LiquorListViewModel {
    func viewDidLoad() {
        fetchKeywords()
        Observable.combineLatest(rxSelectedType, rxSelectedKeyword)
            .subscribe(onNext: { [weak self] _, _ in
                self?.repository.resetPagination()
                self?.rxLiquors.accept([])
                self?.fetchLiquors()
            })
            .disposed(by: disposeBag)
    }
}
