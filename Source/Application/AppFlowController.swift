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
final class AppFlowController: StoriesViewControllerDelegate, InfoViewControllerDelegate {

    // MARK: Properties

    fileprivate let rootViewController: UITabBarController

    // MARK: Initialization

    init() {
        // Setup view controller hierarchy.
        rootViewController = UITabBarController()

        let newestStoriesViewController = StoriesViewController(type: .hottest)
        let hottestStoriesViewController = StoriesViewController(type: .newest)
        let infoViewController = InfoViewController()

        infoViewController.delegate = self
        newestStoriesViewController.delegate = self
        hottestStoriesViewController.delegate = self

        rootViewController.viewControllers = [
            UINavigationController(rootViewController: newestStoriesViewController),
            UINavigationController(rootViewController: hottestStoriesViewController),
            UINavigationController(rootViewController: infoViewController)
        ]
    }

    // MARK: Public Interface

    func install(inWindow window: UIWindow) {
        window.rootViewController = rootViewController
    }

    // MARK: Helpers

    fileprivate func presentUrl(url: URL) {
        let viewController = SFSafariViewController(url: url)
        viewController.view.tintColor = AppTheme.lobstersRed
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: StoriesViewControllerDelegate

    func storiesViewController(storiesViewController: StoriesViewController, selectedStory story: Story) {
        presentUrl(url: story.urlToShow)
    }

    func storiesViewController(storiesViewController: StoriesViewController, selectedCommentsForStory story: Story) {
        presentUrl(url: story.commentsUrl)
    }

    // MARK: InfoViewControllerDelegate

    func infoViewController(infoViewController: InfoViewController, selectedUrl url: URL) {
        presentUrl(url: url)
    }

}

extension Story {

    /// The URL to show for a story. Ensures text posts show the comments page.
    var urlToShow: URL {
        if let url = url {
            return url
        } else {
            return commentsUrl
        }
    }

}
