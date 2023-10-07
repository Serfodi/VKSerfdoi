//
//  TitleView.swift
//  VK
//
//  Created by Сергей Насыбуллин on 07.10.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit


protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    
    private var textFiel = InsetableTextField()
    
    private var profileImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(profileImageView)
        
        makeConstraints()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func set(userViewModel: TitleViewViewModel) {
        profileImageView.set(imageURL: userViewModel.photoUrlString)
    }
    
    
    
    private func makeConstraints() {
        profileImageView.anchor(top: topAnchor,
                                leading: leadingAnchor, bottom: nil,
                                trailing: nil,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16),
                                size: CGSize(width: 44, height: 44))
        
////        profileImageView.heightAnchor.constraint(equalTo: 32, multiplier: 1).isActive = true
//        profileImageView.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1, constant: 32).isActive = true
//        profileImageView.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1, constant: 32).isActive = true
    }
    
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    
}
