//
//  AppTheme.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Configures UIAppearance proxies to globally theme app.
final class AppTheme {

    // MARK: Static Properties

    static let lobstersRed = UIColor.red

    // MARK: Public Interface

    static func apply() {
        UITabBar.appearance().tintColor = lobstersRed
        UIBarButtonItem.appearance().tintColor = lobstersRed
        
    }

}
