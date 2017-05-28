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

    // MARK: Internal Types

    struct TableSection {
        let title: String
        let links: [(String, URL)]
    }

    // MARK: Static Properties

    fileprivate static let cellIdentifier = "InfoCellIdentifier"

    // MARK: Properties

    var delegate: InfoViewControllerDelegate?

    fileprivate let tableData = [
        TableSection(title: "Lobste.rs Links", links: [
            (title: "Hats", link: URL(string: "https://lobste.rs/hats")!),
            (title: "Moderation Log", link: URL(string: "https://lobste.rs/moderations")!),
            (title: "About Lobste.rs", link: URL(string: "https://lobste.rs/about")!)
        ]),
        TableSection(title: "Source Code", links: [
            (title: "App Source Code", link: URL(string: "https://github.com/cfdrake/lobsters-reader")!),
            (title: "Unbox", link: URL(string: "https://github.com/JohnSundell/Unbox")!),
            (title: "Result", link: URL(string: "https://github.com/antitypical/Result")!)
        ]),
        TableSection(title: "Icons", links: [
            (title: "Icons from Icons8", link: URL(string: "https://icons8.com")!)
        ])
    ]

    // MARK: Initialization

    init() {
        super.init(style: .grouped)

        title = "Info"
        tabBarItem = UITabBarItem(title: "Info", image: UIImage.init(named: "InfoIcon"), selectedImage: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: InfoViewController.cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].links.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoViewController.cellIdentifier, for: indexPath)
        let (title, _) = tableData[indexPath.section].links[indexPath.row]

        cell.textLabel?.text = title
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, link) = tableData[indexPath.section].links[indexPath.row]
        delegate?.infoViewController(infoViewController: self, selectedUrl: link)
    }

}
