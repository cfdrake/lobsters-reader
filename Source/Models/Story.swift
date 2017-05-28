//
//  Story.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Unbox

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

    var urlDomain: String? {
        guard let url = url else { return nil }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.host?.replacingOccurrences(of: "www.", with: "")
    }

}

extension Story: Unboxable {

    static let sharedDateFormatter = ISO8601DateFormatter()

    init(unboxer: Unboxer) throws {
        shortIdUrl = try unboxer.unbox(key: "short_id_url")
        commentCount = try unboxer.unbox(key: "comment_count")
        description = try unboxer.unbox(key: "description")
        shortId = try unboxer.unbox(key: "short_id")
        downvotes = try unboxer.unbox(key: "downvotes")
        createdAt = try unboxer.unbox(key: "created_at", formatter: Story.sharedDateFormatter)
        url = unboxer.unbox(key: "url")
        tags = try unboxer.unbox(key: "tags")
        title = try unboxer.unbox(key: "title")
        upvotes = try unboxer.unbox(key: "upvotes")
        commentsUrl = try unboxer.unbox(key: "comments_url")
        score = try unboxer.unbox(key: "score")
    }

}
