//
//  Tag.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/7/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Tag a story may be filed under.
struct Tag {
    let id: Int
    let tag: String
    let description: String
    let privileged: Bool
    let isMedia: Bool
    let inactive: Bool
    let hotnessMod: Int
}
