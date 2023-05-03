//
//  YoutubePlaylistItem.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubePlaylistItem
struct YoutubePlaylistItem: Codable {
    let nextPageToken, prevPageToken: String?
    let items: [Item]
    let pageInfo: PageInfo

    // MARK: - Item
    struct Item: Codable {
        let contentDetails: ContentDetails
    }

    // MARK: - ContentDetails
    struct ContentDetails: Codable {
        let videoId: String
    }

    // MARK: - PageInfo
    struct PageInfo: Codable {
        let totalResults, resultsPerPage: Int
    }
}
