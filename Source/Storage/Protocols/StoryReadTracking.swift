//
//  StoryReadTracking.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

protocol StoryReadTracking {
    func markStoryRead(story: Story)
    func isStoryRead(story: Story) -> Bool
}
