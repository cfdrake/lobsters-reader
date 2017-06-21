//
//  Logger.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import Foundation

func debugLog(_ message: String) {
    #if DEBUG
        NSLog(message)
    #endif
}
