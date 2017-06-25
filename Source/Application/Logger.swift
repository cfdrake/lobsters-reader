//
//  Logger.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

/// Debug logger.
final class Logger {
    static let shared = Logger()

    func log(_ message: String) {
        #if DEBUG
            NSLog(message)
        #endif
    }
}
