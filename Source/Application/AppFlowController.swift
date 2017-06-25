//
//  AppFlowController.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit
import SafariServices

/// Main app flow controller responsible for application navigation and view controller management.
final class AppFlowController: NSObject, StoriesViewControllerDelegate, InfoViewControllerDelegate, TagsViewControllerDelegate, UITabBarControllerDelegate {
    fileprivate let rootViewController: UITabBarController
    fileprivate let client = APIClient()

    init(withWindow window: UIWindow) {
        // Apply theme.
        AppTheme.apply()

        // Setup view controller hierarchy.
        rootViewController = UITabBarController()

        let newestStoriesViewController = StoriesViewController(type: .hottest, fetcher: client)
        let hottestStoriesViewController = StoriesViewController(type: .newest, fetcher: client)
        let infoViewController = InfoViewController(info: defaultAppInfo)
        let tagsViewController = TagsViewController()

        super.init()

        infoViewController.delegate = self
        newestStoriesViewController.delegate = self
        hottestStoriesViewController.delegate = self
        tagsViewController.delegate = self

        rootViewController.delegate = self
        rootViewController.viewControllers = [
            UINavigationController(rootViewController: newestStoriesViewController),
            UINavigationController(rootViewController: hottestStoriesViewController),
            UINavigationController(rootViewController: tagsViewController),
            UINavigationController(rootViewController: infoViewController)
        ]

        // Install into window.
        Logger.shared.log("Installing app flow controller...")
        window.rootViewController = rootViewController
    }

    // MARK: 3D Touch Shortcuts

    fileprivate enum Shortcut: String {
        case hottest, newest, tags

        static let all: [Shortcut] = [.hottest, .newest, .tags]
        var tabIndex: Int {
            return Shortcut.all.index(of: self)!
        }
    }

    var shortcutItems: [UIApplicationShortcutItem] {
        return Shortcut.all.map { shortcut in
            let identifier = shortcut.rawValue
            let name = identifier.localizedCapitalized
            let icon = UIApplicationShortcutIcon(templateImageName: "\(name)Icon")
            return UIApplicationShortcutItem(type: identifier, localizedTitle: name, localizedSubtitle: nil, icon: icon, userInfo: nil)
        }
    }

    func attemptToHandle(shortcut: UIApplicationShortcutItem) -> Bool {
        guard let shortcut = Shortcut(rawValue: shortcut.type) else {
            return false
        }

        rootViewController.selectedIndex = shortcut.tabIndex
        return true
    }

    // MARK: Helpers

    fileprivate func controllerToShow(url: URL) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredControlTintColor = .lobstersRed
        return viewController
    }

    // MARK: UITabBarDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedController = tabBarController.selectedViewController else { return true }
        guard let viewController = viewController as? UINavigationController else { return true }

        // Check if we're selecting an already selected view controller.
        // If so, allow power users to use this bounce to top of stories controller, or back to tags listing.
        if selectedController == viewController {
            if let viewController = viewController.viewControllers.first as? StoriesViewController {
                viewController.scrollToTop()
            } else if let viewController = viewController.viewControllers.first as? TagsViewController {
                viewController.navigationController?.popViewController(animated: true)
            }
        }

        return true
    }

    // MARK: StoriesViewControllerDelegate

    func showStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) {
        let viewController = controllerToShow(url: story.viewableUrl)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    func showCommentsForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) {
        let viewController = controllerToShow(url: story.commentsUrl)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    func previewingViewControllerForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) -> UIViewController {
        let viewController = controllerToShow(url: story.viewableUrl)
        return viewController
    }

    func commitPreviewingViewControllerForStory(_ viewController: UIViewController, storiesViewController: StoriesViewController) {
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: InfoViewControllerDelegate

    func infoViewController(infoViewController: InfoViewController, selectedUrl url: URL) {
        let viewController = controllerToShow(url: url)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: TagsViewControllerDelegate

    func tagsViewController(tagsViewController: TagsViewController, selectedTag tag: String) {
        guard let navigationController = tagsViewController.navigationController else {
            return
        }

        let tagViewController = StoriesViewController(type: FeedType.tagged(tag), fetcher: client)
        tagViewController.delegate = self
        navigationController.pushViewController(tagViewController, animated: true)
    }
}
