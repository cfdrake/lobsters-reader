//
//  Story+Unboxable.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Unbox

/// Adds Unboxable adherence for Story type.
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
