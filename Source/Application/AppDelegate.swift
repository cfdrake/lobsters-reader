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

    // MARK: Types

    enum ShortcutItem: String {
        case hottest, newest, tags
    }

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Apply theme.
        AppTheme.apply()

        // Setup view controllers.
        let window = UIWindow(frame: UIScreen.main.bounds)

        flowController = AppFlowController()
        flowController?.install(inWindow: window)

        window.makeKeyAndVisible()
        self.window = window

        // Install 3D touch shortcuts.
        let items = [ShortcutItem.hottest, ShortcutItem.newest, ShortcutItem.tags]

        application.shortcutItems = items.map { item in
            let itemName = item.rawValue.localizedCapitalized
            let iconName = "\(itemName)Icon"
            let icon = UIApplicationShortcutIcon(templateImageName: iconName)
            return UIApplicationShortcutItem(type: item.rawValue, localizedTitle: itemName, localizedSubtitle: nil, icon: icon, userInfo: nil)
        }

        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Shortcut into the correct tab.
        guard let shortcut = ShortcutItem(rawValue: shortcutItem.type) else {
            completionHandler(false)
            return
        }

        switch shortcut {
        case .hottest:
            flowController?.show(tab: .hottest)
        case .newest:
            flowController?.show(tab: .newest)
        case .tags:
            flowController?.show(tab: .tags)
        }

        completionHandler(true)
    }
}
