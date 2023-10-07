//
//  InsetableTextField.swift
//  VK
//
//  Created by Сергей Насыбуллин on 07.10.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

class InsetableTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
        placeholder = "Поиск"
        font = Constanst.postLabelFount
        clearButtonMode = .whileEditing
        borderStyle = .none
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
