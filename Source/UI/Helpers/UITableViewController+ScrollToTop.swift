//
//  UITableView+ScrollToTop.swift
//  LobstersReader
//
//  Created by Colin Drake on 6/25/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

extension UITableViewController {
    /// Scrolls the embedded table view to top.
    func scrollToTop() {
        let topRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        tableView.scrollRectToVisible(topRect, animated: true)
    }
}
