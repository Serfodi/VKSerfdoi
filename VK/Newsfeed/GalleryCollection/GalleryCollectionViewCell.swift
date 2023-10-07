//
//  GalleryCollectionViewCell.swift
//  VK
//
//  Created by Сергей Насыбуллин on 30.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit


class  GalleryCollectionViewCell: UICollectionViewCell {
    
    let imageView: WebImageView = {
        let imageVeiw = WebImageView()
        imageVeiw.translatesAutoresizingMaskIntoConstraints = false
        imageVeiw.contentMode = .scaleAspectFill
        imageVeiw.backgroundColor = .gray
        return imageVeiw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.fillSuperview()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constanst.radius
    }
    
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func set(imageUrl: String?) {
        imageView.set(imageURL: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
