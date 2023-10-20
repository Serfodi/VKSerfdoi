//
//  BlurGradientView.swift
//  VK
//
//  Created by Сергей Насыбуллин on 30.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit


class BlurGradientView: UIVisualEffectView {

    private let gradientLayer = CAGradientLayer()
    
    var locationsGradient: [NSNumber] = [0, 0.6]
    
    var colors:[CGColor] = [
        CGColor(gray: 0, alpha: 0),
        CGColor(gray: 1, alpha: 1)
    ]
        
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        effect = UIBlurEffect(style: .dark)
        
        backgroundColor = .clear
        
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
        
        layer.mask = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
    }
}
