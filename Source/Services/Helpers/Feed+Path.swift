//
//  Feed+Path.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

extension Feed {
    /// The relative path at which a feed's contents may be fetched.
    var path: String {
        switch self {
        case .hottest: return "/hottest.json"
        case .newest: return "/newest.json"
        case let .tagged(tag): return "/\(tag).json"
        }
    }
}
