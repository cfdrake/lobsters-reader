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
    func storiesViewController(storiesViewController: StoriesViewController, selectedStory: Story)
    func storiesViewController(storiesViewController: StoriesViewController, selectedCommentsForStory: Story)
}

/// Displays a list of stories.
final class StoriesViewController: UITableViewController, StoryTableViewCellDelegate {

    // MARK: Properties

    var delegate: StoriesViewControllerDelegate?
    fileprivate let client = APIClient.defaultClient
    fileprivate let type: StoryType
    fileprivate var page = 1
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

    // MARK: Initialization

    init(type: StoryType) {
        self.type = type
        self.stories = []

        super.init(style: .plain)

        let typeString = String(describing: type)
        let typeIcon = UIImage.init(named: "\(typeString)Icon")

        title = typeString
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        tabBarItem = UITabBarItem(title: typeString, image: typeIcon, selectedImage: nil)
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

        client.fetchStories(ofType: type, page: page) { [unowned self] result in
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

        client.fetchStories(ofType: type, page: page) { [unowned self] result in
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

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let story = stories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.cellIdentifier, for: indexPath) as! StoryTableViewCell

        cell.storyTitleLabel?.text = story.title
        cell.storyScoreLabel?.text = "\(story.score)"
        cell.storySubmitDateLabel?.text = "Submitted \(story.createdAt.timeAgo())"
        cell.storyCommentsButton?.setTitle("\(story.commentCount)", for: .normal)
        cell.delegate = self
        cell.tag = indexPath.row
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if let domain = story.urlDomain {
            cell.storyDomainLabel?.text = domain
        } else {
            cell.storyDomainLabel?.text = "text"
        }

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        delegate?.storiesViewController(storiesViewController: self, selectedStory: story)
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
        let story = stories[index]
        delegate?.storiesViewController(storiesViewController: self, selectedCommentsForStory: story)
    }

}
