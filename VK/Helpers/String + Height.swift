//
//  String + Height.swift
//  VK
//
//  Created by Сергей Насыбуллин on 23.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

extension String {
    
    func height(widht: CGFloat, fount: UIFont) -> CGFloat {
        let textSize = CGSize(width: widht, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : fount],
                                     context: nil)
        return ceil( size.height )
    }
    
}
