//
//  Story.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Represents a user-submitted story.
struct Story {
    let shortIdUrl: URL
    let commentCount: Int
    let description: String
    let shortId: String
    let downvotes: Int
    let createdAt: Date
    let url: URL?
    let tags: [String]
    let title: String
    let upvotes: Int
    let commentsUrl: URL
    let score: Int
}
