//
//  StoryFetching.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Result

/// Describes the reason stories could not be fetched.
struct StoryFetchingError: Error {
    let reason: String
}

/// A type that supports async fetching of stories from a feed.
protocol StoryFetching {
    func fetchStories(fromFeed feed: Feed, page: UInt, completion: @escaping (Result<[Story], StoryFetchingError>) -> Void)
}
