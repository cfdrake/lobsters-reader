//
//  String+Pluralize.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

extension String {
    /// Naive, but workable for this app, implementation of string pluralization.
    func pluralize(_ n: Int) -> String {
        return n == 1 ? self : self + "s"
    }
}
