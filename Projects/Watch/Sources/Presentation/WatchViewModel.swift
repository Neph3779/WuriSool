//
//  WatchViewModel.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WatchDomain

final class WatchViewModel {

    private let disposeBag = DisposeBag()
    private let repository: WatchRepositoryInterface
    let videos = BehaviorRelay<[YoutubeVideo]>(value: [])
    var selectedChannel = BehaviorRelay<LiquorChannel>(value: .drinkHouse)

    init(repository: WatchRepositoryInterface) {
        self.repository = repository
        fetchVideos()
        selectedChannel
            .asDriver()
            .drive { [weak self] channel in
                self?.videos.accept([])
                self?.fetchVideos()
            }
            .disposed(by: disposeBag)
    }

    func fetchVideos() {
        Task {
            do {
                let data = try await repository.fetchVideos(of: selectedChannel.value)
                videos.accept(data)
            } catch {
                print(error)
            }
        }
    }
}
