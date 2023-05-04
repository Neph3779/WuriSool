//
//  YoutubeRepository.swift
//  Network
//
//  Created by 천수현 on 2023/05/04.
//  Copyright © 2023 com.neph. All rights reserved.
//

import Foundation
import OSLog
import BaseDomain
import Alamofire

public protocol YoutubeRepositoryInterface {
    func fetchVideos(of channel: LiquorChannel, maxResults: Int, nextPageToken: String?) async throws -> [String]
    func fetchVideo(id: String) async throws -> YoutubeVideo
}

public final class YoutubeRepository: YoutubeRepositoryInterface {
    private let logId = UUID()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: "YoutubeRepository")
    private let baseURL = "https://youtube.googleapis.com/youtube/v3"

    private var apiKey: String {
        guard let path = NetworkResources.bundle.path(forResource: "APIKeys", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let apiKey = dictionary["YOUTUBE_API_KEY"] as? String else {
            logger.log("Can not find api key")
            return ""
        }
        return apiKey
    }

    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Session(configuration: configuration)
      }()

    public init() {
        
    }

    public func fetchVideos(of channel: LiquorChannel, maxResults: Int = 10, nextPageToken: String? = nil) async throws -> [String] {
        let channel = try await fetchChannel(id: channel.channelId)
        let playListItem = try await fetchPlayListItem(
            playListId: channel.items.first?.contentDetails.relatedPlaylists.uploads ?? "",
            maxReuslts: maxResults,
            nextPageToken: nextPageToken
        )
        return playListItem.items.map { $0.contentDetails.videoId }
    }

    public func fetchVideo(id: String) async throws -> YoutubeVideo {
        let path = "/videos"
        let parameters: [String: Any] = [
            "part": "snippet",
            "id": id,
            "key": apiKey
        ]
        let request = session.request(baseURL + path, method: .get, parameters: parameters)
        return try await request.serializingDecodable(YoutubeVideo.self).value
    }

    private func fetchChannel(id: String) async throws -> YoutubeChannel {
        let path = "/channels"
        let parameters: [String: Any] = [
            "part": "snippet,contentDetails",
            "id": id,
            "key": apiKey
        ]

        let request = session.request(baseURL + path, method: .get, parameters: parameters)
        return try await request.serializingDecodable(YoutubeChannel.self).value
    }

    private func fetchPlayListItem(playListId: String, maxReuslts: Int, nextPageToken: String?) async throws -> YoutubePlaylistItem {
        let path = "/playlistItems"
        var parameters: [String: Any] = [
            "part": "contentDetails",
            "maxResults": maxReuslts,
            "playlistId": playListId,
            "key": apiKey
        ]
        if let nextPageToken = nextPageToken {
            parameters.updateValue(nextPageToken, forKey: "pageToken")
        }
        let request = session.request(baseURL + path, method: .get, parameters: parameters)
        return try await request.serializingDecodable(YoutubePlaylistItem.self).value
    }
}
