//
//  WatchRepository.swift
//  Watch
//
//  Created by 천수현 on 2023/05/03.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Network
import WatchDomain

final class WatchRepository: WatchRepositoryInterface {

    private let youtubeRepository: YoutubeRepositoryInterface

    init(youtubeRepository: YoutubeRepositoryInterface = YoutubeRepository()) {
        self.youtubeRepository = youtubeRepository
    }

    func fetchVideos(of channel: LiquorChannel) async throws -> [YoutubeVideo] {
        let videoIds = try await youtubeRepository.fetchVideos(of: channel, maxResults: 10, nextPageToken: nil)
        let orderedVideoIds = videoIds.enumerated().map { (index, item) -> (index: Int, id: String) in
            return (index, item)
        }
        var results = [YoutubeVideo]()

        for video in orderedVideoIds {
            results.append(try await youtubeRepository.fetchVideo(id: video.id))
        }
        return results
    }
}
