//
//  StoriesViewController.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/27/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Delegate protocol for StoriesViewController interactions.
protocol StoriesViewControllerDelegate {
    func showStory(_ story: StoryViewModel, storiesViewController: StoriesViewController)
    func showCommentsForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController)
    func previewingViewControllerForStory(_ story: StoryViewModel, storiesViewController: StoriesViewController) -> UIViewController
    func commitPreviewingViewControllerForStory(_ viewController: UIViewController, storiesViewController: StoriesViewController)
}

/// View controller displaying a list of stories.
final class StoriesViewController: UITableViewController, StoryTableViewCellDelegate, UIViewControllerPreviewingDelegate {
    var delegate: StoriesViewControllerDelegate?
    fileprivate let fetcher: FeedPageFetching
    fileprivate let type: FeedType
    fileprivate var page: UInt
    fileprivate let readTracker: StoryReadTracking
    fileprivate var stories: [Story] {
        didSet {
            guard self.isViewLoaded else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.flashScrollIndicators()
            }
        }
    }
    fileprivate var loading = false {
        didSet {
            guard self.isViewLoaded else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }

    init(type: FeedType, fetcher: FeedPageFetching, readTracker: StoryReadTracking) {
        self.type = type
        self.fetcher = fetcher
        self.page = 1
        self.stories = []
        self.readTracker = readTracker

        super.init(style: .plain)

        title = type.asTitle
        tabBarItem = UITabBarItem(title: type.asTitle, image: type.icon, selectedImage: type.iconFilled)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        // Configure views.
        tableView.register(StoryTableViewCell.nib, forCellReuseIdentifier: StoryTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(StoriesViewController.refresh), for: .valueChanged)

        // Set up 3D touch.
        registerForPreviewing(with: self, sourceView: view)

        // Fetch initial story set.
        refresh()
    }

    // MARK: UI Helpers

    fileprivate func presentLoadingError() {
        let alertController = UIAlertController(title: "Uh-oh!", message: "We couldn't load any stories! Please check your network connection then tap the refresh icon.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: Data Helpers

    @objc fileprivate func refresh() {
        page = 1
        loading = true

        tableView.refreshControl?.beginRefreshing()

        fetcher.fetch(feed: type, page: page) { [unowned self] result in
            self.loading = false

            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }

            switch result {
            case let .success(initialStories):
                self.stories = initialStories
                self.page += 1
            case .failure(_):
                self.stories = []
                DispatchQueue.main.async(execute: self.presentLoadingError)
            }
        }
    }

    fileprivate func loadNextPage() {
        loading = true

        fetcher.fetch(feed: type, page: page) { [unowned self] result in
            self.loading = false

            switch result {
            case let .success(moreStories):
                self.stories.append(contentsOf: moreStories)
                self.page += 1
            case let .failure(error):
                print("TODO: Display next page loading error...")
                return
            }
        }
    }

    fileprivate func viewModelForRow(_ row: Int) -> StoryViewModel {
        let story = stories[row]
        return StoryViewModel(story: story)
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModelForRow(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.cellIdentifier, for: indexPath) as! StoryTableViewCell

        cell.configure(viewModel: viewModel, unread: !readTracker.isStoryRead(story: stories[indexPath.row]))
        cell.delegate = self
        cell.tag = indexPath.row

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModelForRow(indexPath.row)
        delegate?.showStory(viewModel, storiesViewController: self)

        // Mark as read.
        readTracker.markStoryRead(story: stories[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .automatic)

        // Fix selection style being persisted.
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }

    // MARK: UIScrollViewDelegate

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard stories.count > 0 && !loading else { return }

        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset

        if distanceFromBottom < height {
            loadNextPage()
        }
    }

    // MARK: StoryTableViewCellDelegate

    func tappedCommentsButton(inStoryTableViewCell cell: StoryTableViewCell) {
        let index = cell.tag
        let viewModel = viewModelForRow(index)
        delegate?.showCommentsForStory(viewModel, storiesViewController: self)
    }

    // MARK: UIViewControllerPreviewingDelegate

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }

        let viewModel = viewModelForRow(indexPath.row)
        return delegate?.previewingViewControllerForStory(viewModel, storiesViewController: self)
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        delegate?.commitPreviewingViewControllerForStory(viewControllerToCommit, storiesViewController: self)
    }
}
