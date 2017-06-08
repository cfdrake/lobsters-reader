//
//  Tag.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/7/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Unbox

/// Represents a tag on a story.
struct Tag {

    let id: Int
    let tag: String
    let description: String
    let privileged: Bool
    let isMedia: Bool
    let inactive: Bool
    let hotnessMod: Int

}

extension Tag: Unboxable {

    init(unboxer: Unboxer) throws {
        id = try unboxer.unbox(key: "id")
        tag = try unboxer.unbox(key: "tag")
        description = try unboxer.unbox(key: "description")
        privileged = try unboxer.unbox(key: "privileged")
        isMedia = try unboxer.unbox(key: "is_media")
        inactive = try unboxer.unbox(key: "inactive")
        hotnessMod = try unboxer.unbox(key: "hotness_mod")
    }
    
}
