//
//  InMemoryStoryReadTracker.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

final class InMemoryStoryReadTracker: StoryReadTracking {
    var cache = Set<String>()

    func markStoryRead(story: Story) {
        cache.insert(story.shortId)
    }

    func isStoryRead(story: Story) -> Bool {
        return cache.contains(story.shortId)
    }
}
