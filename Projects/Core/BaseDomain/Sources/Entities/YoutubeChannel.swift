//
//  YoutubeChannel.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubeChannel
public struct YoutubeChannel: Decodable {
    public let items: [Item]

    // MARK: - Item
    public struct Item: Decodable {
        public let snippet: Snippet
        public let contentDetails: ContentDetails
    }

    // MARK: - ContentDetails
    public struct ContentDetails: Decodable {
        public let relatedPlaylists: RelatedPlaylists
    }

    // MARK: - RelatedPlaylists
    public struct RelatedPlaylists: Decodable {
        public let uploads: String
    }

    // MARK: - Snippet
    public struct Snippet: Decodable {
        public let title, description: String
        public let thumbnails: Thumbnails
    }

    // MARK: - Thumbnails
    public struct Thumbnails: Decodable {
        public let `default`: Default
    }

    // MARK: - Default
    public struct Default: Decodable {
        public let url: String
    }
}
