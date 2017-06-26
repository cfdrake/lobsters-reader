//
//  PersistentStoryReadTracker.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Persistent file-backed story read tracker.
final class PersistentStoryReadTracker: StoryReadTracking {
    let cacheFilePath: String
    var cache: Set<String>

    init(cacheFilePath: String) {
        self.cacheFilePath = cacheFilePath
        self.cache = Set()

        if let cache = NSKeyedUnarchiver.unarchiveObject(withFile: cacheFilePath) as? Set<String> {
            self.cache = cache
        }
    }

    func markStoryRead(story: Story) {
        cache.insert(story.shortId)
    }

    func isStoryRead(story: Story) -> Bool {
        return cache.contains(story.shortId)
    }

    func save() {
        NSKeyedArchiver.archiveRootObject(cache, toFile: cacheFilePath)
    }
}
