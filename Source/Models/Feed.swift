//
//  Feed.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Represents a type of feed.
enum Feed {
    case hottest, newest, tagged(String)
}
