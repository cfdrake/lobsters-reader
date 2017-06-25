//
//  Feed.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Appendable feed of stories.
struct Feed {
    let type: FeedType
    let stories: [Story]

    static func empty(type: FeedType) -> Feed {
        return Feed(type: type, stories: [])
    }

    func appending(page: FeedPage) -> Feed {
        return Feed(type: type, stories: stories + page)
    }
}
