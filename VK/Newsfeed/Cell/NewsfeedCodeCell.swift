//
//  NewsfeedCodeCell.swift
//  VK
//
//  Created by Сергей Насыбуллин on 27.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

final class NewsfeedCodeCell: UITableViewCell {

    static let reuseId = "NewsfeedCodeCell"
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Constanst.cardViewColor
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // second layer
    
    let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    let postlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Constanst.postLabelFount
        label.textColor = .white
        return label
    }()
    
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // third layer on profile view
    
    let iconImageView: WebImageView = {
        let image = WebImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constanst.nameLabelFount
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constanst.dateLabelFount
        label.textColor = Constanst.labelSecondFountColor
        return label
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayerOnTopView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconImageString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postlabel.text = viewModel.post
        
        postImageView.frame = viewModel.sizes.attachmentFramge
        postlabel.frame = viewModel.sizes.postLabelFrame
        profileView.frame = viewModel.sizes.bottomView
        
        if let photoAttachment = viewModel.photoAttachement {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
    
    
    
    func overlayThirdLayerOnTopView() {
        profileView.addSubview(iconImageView)
        profileView.addSubview(dateLabel)
        profileView.addSubview(nameLabel)
        
        // iconImageView constraint
        iconImageView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -12).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        // nameLabel constraint
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: 5).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        // dateLabel constraint
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -12).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -15).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        iconImageView.layer.cornerRadius = 20
    }
    
    
    func overlaySecondLayer() {
        cardView.addSubview(postImageView)
        cardView.addSubview(postlabel)
        cardView.addSubview(profileView)
    }
    
    func overlayFirstLayer() {
        addSubview(cardView)
        // add constraint
        cardView.fillSuperview(padding: Constanst.cardInserts)
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
