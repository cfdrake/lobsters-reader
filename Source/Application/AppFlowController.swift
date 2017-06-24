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
final class AppFlowController: StoriesViewControllerDelegate, InfoViewControllerDelegate, TagsViewControllerDelegate {
    fileprivate let rootViewController: UITabBarController
    fileprivate let client = APIClient.default

    init() {
        // Setup view controller hierarchy.
        rootViewController = UITabBarController()

        let newestStoriesViewController = StoriesViewController(feed: .hottest, fetcher: client)
        let hottestStoriesViewController = StoriesViewController(feed: .newest, fetcher: client)
        let infoViewController = InfoViewController(info: defaultAppInfo)
        let tagsViewController = TagsViewController()

        infoViewController.delegate = self
        newestStoriesViewController.delegate = self
        hottestStoriesViewController.delegate = self
        tagsViewController.delegate = self

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

    fileprivate func presentUrl(url: URL) {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredControlTintColor = .lobstersRed

        debugLog("Presenting \(url) in SFSafariViewController...")

        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: StoriesViewControllerDelegate

    func storiesViewController(storiesViewController: StoriesViewController, selectedStory story: StoryViewModel) {
        presentUrl(url: story.viewableUrl)
    }

    func storiesViewController(storiesViewController: StoriesViewController, selectedCommentsForStory story: StoryViewModel) {
        presentUrl(url: story.commentsUrl)
    }

    func storiesViewController(storiesViewController: StoriesViewController, viewControllerForPreviewOfStory story: StoryViewModel) -> UIViewController {
        let viewController = SFSafariViewController(url: story.viewableUrl)
        viewController.preferredControlTintColor = .lobstersRed
        return viewController
    }

    func storiesViewController(storiesViewController: StoriesViewController, commitPreviewOfStoryWithController viewController: UIViewController) {
        rootViewController.present(viewController, animated: true, completion: nil)
    }

    // MARK: InfoViewControllerDelegate

    func infoViewController(infoViewController: InfoViewController, selectedUrl url: URL) {
        presentUrl(url: url)
    }

    // MARK: TagsViewControllerDelegate

    func tagsViewController(tagsViewController: TagsViewController, selectedTag tag: String) {
        let tagViewController = StoriesViewController(feed: Feed.tagged(tag), fetcher: client)
        tagViewController.delegate = self
        tagsViewController.navigationController?.pushViewController(tagViewController, animated: true)
    }
}
