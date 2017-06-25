//
//  FeedType+DisplayHelpers.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Feed icon and title helpers.
extension FeedType {
    var icon: UIImage {
        switch self {
        case .hottest: return #imageLiteral(resourceName: "HottestIcon")
        case .newest: return #imageLiteral(resourceName: "NewestIcon")
        case .tagged: return #imageLiteral(resourceName: "TagsIcon")
        }
    }

    var asTitle: String {
        switch self {
        case .hottest: return "Hottest"
        case .newest: return "Newest"
        case let .tagged(tag): return "#\(tag)"
        }
    }
}
