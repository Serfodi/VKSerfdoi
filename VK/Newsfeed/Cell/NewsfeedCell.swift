//
//  NewsfeedCell.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol FeedCellViewModel {
    var iconImageString: String { get }
    var name: String { get }
    var date: String { get }
    var post: String? { get }
}

class NewsfeedCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postlabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconImageString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postlabel.text = viewModel.post
    }
    
}
