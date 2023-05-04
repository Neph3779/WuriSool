//
//  YoutubePlaylistItem.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubePlaylistItem
public struct YoutubePlaylistItem: Codable {
    public let nextPageToken, prevPageToken: String?
    public let items: [Item]
    public let pageInfo: PageInfo

    // MARK: - Item
    public struct Item: Codable {
        public let contentDetails: ContentDetails
    }

    // MARK: - ContentDetails
    public struct ContentDetails: Codable {
        public let videoId: String
    }

    // MARK: - PageInfo
    public struct PageInfo: Codable {
        public let totalResults, resultsPerPage: Int
    }
}
