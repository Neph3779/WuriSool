//
//  HomeViewModel.swift
//  HomeDomain
//
//  Created by 천수현 on 2023/04/05.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import HomeDomain
import OSLog

public final class HomeViewModel {

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "HomeViewModel")
    private let repository: HomeRepositoryInterface
    var viewTop10Liquors = [Liquor]()
    var buyTop10Liquors = [Liquor]()
    var applyDataSource: ((HomeViewController.HomeSection)-> Void)?

    public init(repository: HomeRepositoryInterface) {
        self.repository = repository
    }
}

// MARK: - View Life Cycle
extension HomeViewModel {
    func viewDidLoad() {
        fetchViewTop10Liquors()
        fetchBuyTop10Liquors()
    }
}

private extension HomeViewModel {
    private func fetchViewTop10Liquors() {
        Task {
            do {
                let liquors = try await repository.fetchViewTop10Liquors()
                applyDataSource?(.viewTop10(liquors))
            } catch {
                logger.log("fetch view top 10 failed \n message: \(error.localizedDescription)")
            }
        }
    }

    private func fetchBuyTop10Liquors() {
        Task {
            do {
                let liquors = try await repository.fetchViewTop10Liquors()
                applyDataSource?(.buyTop10(liquors))
            } catch {
                logger.log("fetch view buy 10 failed \n message: \(error.localizedDescription)")
            }
        }
    }
}
