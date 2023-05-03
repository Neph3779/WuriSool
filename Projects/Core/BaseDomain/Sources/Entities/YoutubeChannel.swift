//
//  YoutubeChannel.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubeChannel
struct YoutubeChannel: Decodable {
    let items: [Item]

    // MARK: - Item
    struct Item: Decodable {
        let snippet: Snippet
        let contentDetails: ContentDetails
    }

    // MARK: - ContentDetails
    struct ContentDetails: Decodable {
        let relatedPlaylists: RelatedPlaylists
    }

    // MARK: - RelatedPlaylists
    struct RelatedPlaylists: Decodable {
        let uploads: String
    }

    // MARK: - Snippet
    struct Snippet: Decodable {
        let title, description: String
        let thumbnails: Thumbnails
    }

    // MARK: - Thumbnails
    struct Thumbnails: Decodable {
        let `default`: Default
    }

    // MARK: - Default
    struct Default: Decodable {
        let url: String
        let width, height: Int
    }
}
