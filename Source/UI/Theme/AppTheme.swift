//
//  AppTheme.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Define app-specific colors.
extension UIColor {
    static let lobstersRed = UIColor(red: 232.0 / 255.0, green: 38.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
}

/// Application themer.
final class AppTheme {
    static func apply() {
        UITabBar.appearance().tintColor = .lobstersRed
        UIBarButtonItem.appearance().tintColor = .lobstersRed
        UINavigationBar.appearance().tintColor = .lobstersRed
    }
}
