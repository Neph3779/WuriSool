//
//  WatchRepositoryInterface.swift
//  Watch
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

public protocol WatchRepositoryInterface {
    func fetchVideos(of channel: LiquorChannel) async throws -> [YoutubeVideo]
}
