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
    var window: UIWindow?
    var flowController: AppFlowController?

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create main window and delegate setup to flow controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let flowController = AppFlowController(withWindow: window)
        application.shortcutItems = flowController.shortcutItems  // Register 3D touch shortcuts.
        self.flowController = flowController

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let flowController = flowController else { return }
        completionHandler(flowController.attemptToHandle(shortcut: shortcutItem))
    }
}
