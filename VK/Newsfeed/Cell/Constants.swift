//
//  Constants.swift
//  VK
//
//  Created by Сергей Насыбуллин on 27.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation
import UIKit

struct Constanst {
    
    static let profileViewHight: CGFloat = 72
    static let profileImageHight: CGFloat = 40
    
    static let cardInserts = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
    static let postInserts = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    static let textInserts = UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
    
    /// Внутрений радиус
    ///
    /// Внутрений радиус = Внешний радиус - отступ от границы
    static let radius = profileViewHight / 2 - max(postInserts.left, postInserts.right)
    
    // Для текста поста
    static let nameLabelFount = UIFont(name: "SF Pro Text", size: 15) // Добавть жирный текст
    static let dateLabelFount = UIFont(name: "SF Pro Text", size: 12)
    static let postLabelFount = UIFont(name: "SF Pro Text", size: 15)

    static let dataLabelColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
    static let secondColor = #colorLiteral(red: 0.5019607843, green: 0.6784313725, blue: 0.862745098, alpha: 1)
    
    // Когда нужно добовлять кнопку еще:
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 7
    
    static let moreTextButtonHeight = Self.profileViewHight / 2
    static let moreTextButtonSize = CGSize(width: 140, height: moreTextButtonHeight)
    
}
