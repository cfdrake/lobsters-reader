//
//  TagFetching.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation
import Result

/// A type that can fetch the list of available tags.
protocol TagFetching {
    func fetchTags(completion: @escaping (Result<[Tag], NSError>) -> Void)
}
