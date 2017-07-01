//
//  TagsViewController.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/20/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Delegate protocol for tag view controller interaction.
protocol TagsViewControllerDelegate {
    func tagsViewController(tagsViewController: TagsViewController, selectedTag: String)
}

/// View controller presenting a list of tags.
final class TagsViewController: UITableViewController {
    let cellIdentifier = "TagsCellIdentifier"
    var delegate: TagsViewControllerDelegate?
    lazy var dataSource: ArrayTableViewDataSource<String, UITableViewCell> = {
        return ArrayTableViewDataSource(objects: tags, cellIdentifier: self.cellIdentifier) { (cell, tag) in
            cell.textLabel?.text = "#\(tag)"
            cell.accessoryType = .disclosureIndicator
        }
    }()

    init() {
        super.init(style: .plain)
        title = "Tags"
        tabBarItem = UITabBarItem(title: "Tags", image: #imageLiteral(resourceName: "TagsIcon"), selectedImage: #imageLiteral(resourceName: "TagsIconFilled"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = dataSource
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        delegate?.tagsViewController(tagsViewController: self, selectedTag: tag)

        // Fix selection style being persisted.
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
}
