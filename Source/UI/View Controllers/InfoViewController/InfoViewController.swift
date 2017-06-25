//
//  InfoViewController.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Delegate protocol for Info view controller.
protocol InfoViewControllerDelegate {
    func infoViewController(infoViewController: InfoViewController, selectedUrl url: URL)
}

/// Presents basic app information to the user.
final class InfoViewController: UITableViewController {
    fileprivate static let cellIdentifier = "InfoCellIdentifier"
    fileprivate let info: AppInfoViewModel
    var delegate: InfoViewControllerDelegate?

    init(info: AppInfoViewModel) {
        self.info = info

        super.init(style: .grouped)

        title = "Info"
        tabBarItem = UITabBarItem(title: "Info", image: UIImage.init(named: "InfoIcon"), selectedImage: UIImage.init(named: "InfoIconFilled"))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: InfoViewController.cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return info.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info[section].links.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return info[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoViewController.cellIdentifier, for: indexPath)
        let (title, _) = info[indexPath.section].links[indexPath.row]
        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, link) = info[indexPath.section].links[indexPath.row]
        delegate?.infoViewController(infoViewController: self, selectedUrl: link)
    }
}
