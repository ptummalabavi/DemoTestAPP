//
//  FeedData.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import Foundation

// MARK: - FeedData
struct FeedData: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let results: [FeedResult]
}

// MARK: - Result
struct FeedResult: Codable {
    let artistName, id, releaseDate, name: String
    let artistURL: String
    let artworkUrl100: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case artistName, id, releaseDate, name
        case artistURL = "artistUrl"
        case artworkUrl100, url
    }
}
