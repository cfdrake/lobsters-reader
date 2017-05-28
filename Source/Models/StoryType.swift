//
//  StoryType.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Types of stories available to show.
enum StoryType: String, CustomStringConvertible {

    case hottest
    case newest

    var description: String {
        let first = rawValue.characters.first!  // We know our two cases, thus this will not error.
        let firstUppercased = String(first).uppercased()
        let rest = String(rawValue.characters.dropFirst())
        return firstUppercased + rest
    }

}
