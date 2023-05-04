//
//  YoutubeVideo.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubeVideo
public struct YoutubeVideo: Codable, Hashable {
    public let items: [Item]

    // MARK: - Item
    public struct Item: Codable, Hashable {
        public let id: String
        public let snippet: Snippet
    }

    // MARK: - Snippet
    public struct Snippet: Codable, Hashable {
        public let title: String
        public let thumbnails: Thumbnails
        public let channelTitle: String
    }

    // MARK: - Thumbnails
    public struct Thumbnails: Codable, Hashable {
        public let `default`, medium, high, standard: Default
    }

    // MARK: - Default
    public struct Default: Codable, Hashable {
        public let url: String
    }
}
