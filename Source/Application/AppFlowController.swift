//
//  AppFlowController.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit
import SafariServices

/// Flow controller responsible for application navigation and view controller hierarchy/setup.
final class AppFlowController: NSObject, StoriesViewControllerDelegate, InfoViewControllerDelegate, TagsViewControllerDelegate, UITabBarControllerDelegate {
    fileprivate let rootViewController: UITabBarController
    fileprivate let client = APIClient.default

    override init() {
        // Setup view controller hierarchy.
        rootViewController = UITabBarController()

        let newestStoriesViewController = StoriesViewController(feed: .hottest, fetcher: client)
        let hottestStoriesViewController = StoriesViewController(feed: .newest, fetcher: client)
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
    }

    // MARK: Public Interface

    func install(inWindow window: UIWindow) {
        debugLog("Installing app flow controller...")
        window.rootViewController = rootViewController
    }

    // MARK: Helpers

    fileprivate func safariControllerForUrl(_ url: URL) -> SFSafariViewController {
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
                viewController.tableView.setContentOffset(CGPoint.zero, animated: true)
            } else if let viewController = viewController.viewControllers.first as? TagsViewController {
                viewController.navigationController?.popViewController(animated: true)
            }
        }

        return true
    }

    // MARK: StoriesViewControllerDelegate

    func showStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) {
        let viewController = safariControllerForUrl(story.viewableUrl)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    func showCommentsForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) {
        let viewController = safariControllerForUrl(story.commentsUrl)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    func previewingViewControllerForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) -> UIViewController {
        let viewController = safariControllerForUrl(story.viewableUrl)
        return viewController
    }

    func commitPreviewingViewControllerForStory(_ viewController: UIViewController, storiesViewController: StoriesViewController) {
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: InfoViewControllerDelegate

    func infoViewController(infoViewController: InfoViewController, selectedUrl url: URL) {
        let viewController = safariControllerForUrl(url)
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: TagsViewControllerDelegate

    func tagsViewController(tagsViewController: TagsViewController, selectedTag tag: String) {
        guard let navigationController = tagsViewController.navigationController else {
            return
        }

        let tagViewController = StoriesViewController(feed: Feed.tagged(tag), fetcher: client)
        tagViewController.delegate = self
        navigationController.pushViewController(tagViewController, animated: true)
    }
}
