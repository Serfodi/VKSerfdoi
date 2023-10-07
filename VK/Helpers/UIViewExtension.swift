//
//  UIViewExtension.swift
//  VK
//
//  Created by Сергей Насыбуллин on 07.10.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

extension UIView {
    
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
    
}
