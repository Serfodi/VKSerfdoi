//
//  BlurGradientView.swift
//  VK
//
//  Created by Сергей Насыбуллин on 30.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

class BlurGradientView: UIView {

    private let bluerView = UIVisualEffectView()
    private let gradientLayer = CAGradientLayer()
    
    typealias GradientPosition = [NSNumber]
    
    var locationsGradient: GradientPosition = [0, 0.6]
    
    var colors:[CGColor] = [
        CGColor(gray: 0, alpha: 0),
        CGColor(gray: 1, alpha: 1)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bluerView.frame = bounds
        gradientLayer.frame = bounds
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
    }
    
    private func setup() {
        
        let bluerEffect = UIBlurEffect(style: .dark)
        bluerView.effect = bluerEffect
        
        backgroundColor = .clear
        
        bluerView.layer.mask = gradientLayer
        
        layer.insertSublayer(bluerView.layer, at: 0)
    }
    
}

// Преоброзования от черного к нужному
/*
 func filteredImage(cgImage: CGImage, size:CGSize) -> UIImage? {
 if let matrixFilter = CIFilter(name: "CIColorMatrix") {
 matrixFilter.setDefaults()
 matrixFilter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
 let rgbVector = CIVector(x: 0, y: 0, z: 0, w: 0)
 let aVector = CIVector(x: 1, y: 1, z: 1, w: 0)
 matrixFilter.setValue(rgbVector, forKey: "inputRVector")
 matrixFilter.setValue(rgbVector, forKey: "inputGVector")
 matrixFilter.setValue(rgbVector, forKey: "inputBVector")
 matrixFilter.setValue(aVector, forKey: "inputAVector")
 matrixFilter.setValue(CIVector(x: 1, y: 1, z: 1, w: 0), forKey: "inputBiasVector")
 
 if let matrixOutput = matrixFilter.outputImage, let cgImage = CIContext().createCGImage(matrixOutput, from: matrixOutput.extent) {
 return UIImage(cgImage: cgImage)
 }
 
 }
 return nil
 }
 */
