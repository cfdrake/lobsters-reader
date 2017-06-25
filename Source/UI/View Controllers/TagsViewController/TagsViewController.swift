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

/// Default list of tags.
/// TODO: Replace this with a dynamic list eventually.
fileprivate let tags = [
    "ai",
    "android",
    "api",
    "art",
    "ask",
    "assembly",
    "audio",
    "book",
    "browsers",
    "c",
    "c++",
    "cogsci",
    "compilers",
    "compsci",
    "crypto",
    "cryptocurrencies",
    "css",
    "culture",
    "databases",
    "debugging",
    "design",
    "devops",
    "distributed",
    "dotnet",
    "education",
    "elixir",
    "elm",
    "emacs",
    "erlang",
    "event",
    "finance",
    "formalmethods",
    "fortran",
    "freebsd",
    "games",
    "go",
    "graphics",
    "hardware",
    "haskell",
    "historical",
    "ios",
    "java",
    "javascript",
    "job",
    "law",
    "linux",
    "lisp",
    "lua",
    "mac",
    "math",
    "meta",
    "ml",
    "mobile",
    "netbsd",
    "networking",
    "nodejs",
    "objectivec",
    "openbsd",
    "pdf",
    "performance",
    "perl",
    "person",
    "philosophy",
    "php",
    "practices",
    "privacy",
    "programming",
    "python",
    "rant",
    "release",
    "reversing",
    "ruby",
    "rust",
    "satire",
    "scala",
    "scaling",
    "science",
    "security",
    "show",
    "slides",
    "swift",
    "systemd",
    "testing",
    "unix",
    "vcs",
    "video",
    "vim",
    "virtualization",
    "visualization",
    "web",
    "windows"
]

/// View controller presenting a list of tags.
final class TagsViewController: UITableViewController {
    fileprivate static let cellIdentifier = "TagsCellIdentifier"
    var delegate: TagsViewControllerDelegate?

    init() {
        super.init(style: .plain)

        title = "Tags"
        tabBarItem = UITabBarItem(title: "Tags", image: UIImage.init(named: "TagsIcon"), selectedImage: UIImage.init(named: "TagsIconFilled"))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: TagsViewController.cellIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagsViewController.cellIdentifier, for: indexPath)
        cell.textLabel?.text = "#\(tags[indexPath.row])"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        delegate?.tagsViewController(tagsViewController: self, selectedTag: tag)

        // Fix selection style being persisted.
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
}
