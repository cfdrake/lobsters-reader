//
//  ArrayTableViewDataSource.swift
//  LobstersReader
//
//  Created by Colin Drake on 7/1/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

/// Reusable UITableViewDataSource for simple array-backed models.
final class ArrayTableViewDataSource<ModelType, CellType: UITableViewCell>: NSObject, UITableViewDataSource {
    var objects: [ModelType]
    let cellIdentifier: String
    let configureCell: (CellType, ModelType) -> Void

    init(objects: [ModelType], cellIdentifier: String, configureCell: @escaping (CellType, ModelType) -> Void) {
        self.objects = objects
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows", objects.count)
        return objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CellType else {
            fatalError("Could not cast cell to CellType")
        }

        let model = objects[indexPath.row]
        configureCell(cell, model)
        return cell
    }
}
