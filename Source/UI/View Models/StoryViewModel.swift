//
//  StoryViewModel.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// View model for a story.
struct StoryViewModel {
    let title: String
    let score: Int
    let comments: Int
    let urlDomain: String?
    let viewableUrl: URL
    let commentsUrl: URL
    let fuzzyPostedAt: String
}

extension StoryViewModel {
    init(story: Story) {
        title = story.title
        score = story.score
        comments = story.commentCount

        // Choose either external URL, or comments URL for text posts.
        if let url = story.url {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            viewableUrl = url
            urlDomain = components?.host?.replacingOccurrences(of: "www.", with: "")
        } else {
            viewableUrl = story.commentsUrl
            urlDomain = nil
        }

        commentsUrl = story.commentsUrl
        fuzzyPostedAt = story.createdAt.timeAgo()
    }
}
