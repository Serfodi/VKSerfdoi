//
//  NewsfeedCodeCell.swift
//  VK
//
//  Created by Сергей Насыбуллин on 27.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol NewsfeedCodeCellDelegate: AnyObject {
    func revealPost(for cell: NewsfeedCodeCell)
}

final class NewsfeedCodeCell: UITableViewCell {

    static let reuseId = "NewsfeedCodeCell"
    
    weak var delegate: NewsfeedCodeCellDelegate?
    
    private struct StyleCell {
        static let cardColor = UIColor(white: 0.13, alpha: 1)
        static let fountColor = UIColor(white: 0.97, alpha: 1)
    }
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleCell.cardColor
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
        label.textColor = StyleCell.fountColor
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.4431372549, green: 0.4745098039, blue: 0.5019607843, alpha: 1)
        return button
    }()
    
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let galleryCollectionVeiw = GalleryCollectionView()
    
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
        label.textColor = StyleCell.fountColor
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
        moreButton.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)
       
        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayerOnTopView()
    }
    
    @objc func moreTextButtonTouch() {
        delegate?.revealPost(for: self)
    }
    
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconImageString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postlabel.text = viewModel.post
        
        
        postlabel.frame = viewModel.sizes.postLabelFrame
        profileView.frame = viewModel.sizes.profileViewFrame
        moreButton.frame = viewModel.sizes.moreButtonFrame
                
        if let photoAttachment = viewModel.photoAttachements.first, viewModel.photoAttachements.count == 1 {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
            galleryCollectionVeiw.isHidden = true
            postImageView.frame = viewModel.sizes.attachmentFrame
        } else if viewModel.photoAttachements.count > 1 {
            galleryCollectionVeiw.frame = viewModel.sizes.attachmentFrame
            galleryCollectionVeiw.isHidden = false
            postImageView.isHidden = true
            galleryCollectionVeiw.set(photos: viewModel.photoAttachements)
        } else {
            galleryCollectionVeiw.isHidden = true
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
//        cardView.addSubview(galleryCollectionVeiw)
        contentView.addSubview(galleryCollectionVeiw)
        contentView.addSubview(moreButton)
    }
    
    func overlayFirstLayer() {
        addSubview(cardView)
        // add constraint
        cardView.fillSuperview(padding: Constanst.cardInserts)
    }
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
        iconImageView.image = nil
        postImageView.image = nil
        
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
