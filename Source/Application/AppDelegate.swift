//
//  AppDelegate.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Apply theme.
        AppTheme.apply()

        // Create window and install flow controller into it.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let flowController = AppFlowController()

        flowController.install(inWindow: window)
        window.makeKeyAndVisible()

        // Ensure window is retained.
        self.window = window

        return true
    }

}
