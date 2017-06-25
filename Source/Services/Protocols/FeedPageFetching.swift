//
//  FeedPageFetching.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Result

/// A type that can fetch a page of stories for a feed.
protocol FeedPageFetching {
    func fetch(feed: FeedType, page: UInt, completion: @escaping (Result<FeedPage, NSError>) -> Void)
}
