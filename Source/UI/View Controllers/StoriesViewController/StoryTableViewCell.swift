//
//  StoryTableViewCell.swift
//  LobstersReader
//
//  Created by Colin Drake on 5/28/17.
//  Copyright © 2017 Colin Drake. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate {
    func tappedCommentsButton(inStoryTableViewCell cell: StoryTableViewCell)
}

/// Table view cell for stories.
final class StoryTableViewCell: UITableViewCell {
    static let cellIdentifier = "StoryTableViewCell"
    static let nib = UINib(nibName: StoryTableViewCell.cellIdentifier, bundle: .main)

    @IBOutlet var storyTitleLabel: UILabel?
    @IBOutlet var storyScoreLabel: UILabel?
    @IBOutlet var storyDomainLabel: UILabel?
    @IBOutlet var storySubmitDateLabel: UILabel?
    @IBOutlet var storyCommentsButton: UIButton?

    var delegate: StoryTableViewCellDelegate?

    // MARK: UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: Helpers

    func configure(viewModel: StoryViewModel) {
        storyTitleLabel?.text = viewModel.title
        storyScoreLabel?.text = "↑\(viewModel.score)"
        storySubmitDateLabel?.text = "Submitted \(viewModel.fuzzyPostedAt)"
        storyCommentsButton?.setTitle("\(viewModel.comments)", for: .normal)
        storyDomainLabel?.text = viewModel.urlDomain ?? "(text)"
    }

    // MARK: Actions

    @IBAction func tappedCommentsButton() {
        delegate?.tappedCommentsButton(inStoryTableViewCell: self)
    }
}
