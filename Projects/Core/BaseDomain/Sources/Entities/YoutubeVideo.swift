//
//  YoutubeVideo.swift
//  BaseDomain
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation

// MARK: - YoutubeVideo
struct YoutubeVideo: Codable {
    let items: [Item]

    // MARK: - Item
    struct Item: Codable {
        let snippet: Snippet
    }

    // MARK: - Snippet
    struct Snippet: Codable {
        let title: String
        let thumbnails: Thumbnails
        let channelTitle: String
    }

    // MARK: - Thumbnails
    struct Thumbnails: Codable {
        let `default`: Default
    }

    // MARK: - Default
    struct Default: Codable {
        let url: String
    }
}
