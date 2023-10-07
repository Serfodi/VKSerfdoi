//
//  NewsfeedCellLayoutCalculator.swift
//  VK
//
//  Created by Сергей Насыбуллин on 23.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit


protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel], isFullSizePost: Bool) -> FeedCellSizes
}


final class NewsfeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    struct Sizes: FeedCellSizes {
        var postLabelFrame: CGRect
        var attachmentFrame: CGRect
        var profileViewFrame: CGRect
        var moreButtonFrame: CGRect
        var moreGradientView: CGRect
        var locationGradient: [NSNumber]
        var totalHeight: CGFloat
    }
    
    private let screenWidth: CGFloat
    
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    
    /**
     Вычисления размера поста.
     
     Вычисляет размеры поста на наличия фото и текста.
     
     - Parameters:
     - postText: Текст поста
     - photoAttachment: Картинки поста
     - isFullSizePost: Открыт ли текст поста полностью
     
     */
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel], isFullSizePost: Bool) -> FeedCellSizes {
        
        /// Ширина поста
        let cardViewWidth = screenWidth - Constanst.cardInserts.left - Constanst.cardInserts.right
        let width: CGFloat = cardViewWidth - Constanst.postInserts.left - Constanst.postInserts.right
        
        /// Показывать ли кнопку еще
        var showMoreButton = false
        
        
        // MARK: Photo Attachment Frame
        
        var photoAttachmentFrame:CGRect = .zero
        
        // calculations size photoAttachment
        if let attechment = photoAttachments.first {
            
            let ration: CGFloat = CGFloat( Float(attechment.height) / Float(attechment.width) )
            
            if photoAttachments.count == 1 {
                
                photoAttachmentFrame = CGRect(origin: CGPoint(x: Constanst.postInserts.left, y: Constanst.postInserts.top), size: .zero)
                
                let height = width * ration
                photoAttachmentFrame.size = CGSize(width: width, height: height)
                
            } else if photoAttachments.count > 1 {
                
                photoAttachmentFrame = CGRect(origin: CGPoint(x: Constanst.cardInserts.left, y: Constanst.cardInserts.top), size: .zero)
                
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                let rowHight = RowLayout.rowHeightConter(collectionViewWidth: cardViewWidth, photosArray: photos)
                
                photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: rowHight!)
            }
        }
        
        
        
        
        // MARK: Работа с postLabelFrame
        
        var postLabelFrame = CGRect.zero
        
        // calculations size postLabel
        // Show is moreButton if the text is large "showMoreButton"
        if let text = postText, !text.isEmpty {
            
            var height = text.height(widht: width, fount: Constanst.postLabelFount!)
            
            // Добовлять ли кнопку "more"
            let limitHeight = Constanst.postLabelFount!.lineHeight * Constanst.minifiedPostLimitLines
            if !isFullSizePost && height > limitHeight {
                height = Constanst.postLabelFount!.lineHeight * Constanst.minifiedPostLines
                showMoreButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
            
            
            // calculations position postLabel
            var postTextTop: CGFloat = 0
            
            if photoAttachmentFrame.size == CGSize.zero {
                postTextTop = Constanst.profileViewHight
            } else if photoAttachments.count > 1 {
                postTextTop = photoAttachmentFrame.maxY
            } else {
                postTextTop = photoAttachmentFrame.maxY + Constanst.postInserts.bottom
            }
            
            postLabelFrame.origin = CGPoint(x: Constanst.postInserts.left, y: postTextTop)
        }
        
        
        // MARK: moreButton
        // if showMoreButton = true
        
        var moreButtonSize: CGSize = .zero
        
        // calculations size showMoreButton
        if showMoreButton {
            moreButtonSize = Constanst.moreTextButtonSize
        }
        
        // calculations position button
        let centerX = (cardViewWidth - Constanst.moreTextButtonSize.width) / 2
        let centerY = Constanst.moreTextButtonSize.height / 2
        // for text label
        let morelextButtonOrigin = CGPoint(x: centerX, y: postLabelFrame.maxY - centerY)
        let moreButtonFrame = CGRect(origin: morelextButtonOrigin, size: moreButtonSize)
        
        
        // MARK: moreGradientView and locationGradient
        
        var moreGradientSize: CGSize = .zero
        let twoLineText = Constanst.postLabelFount!.lineHeight * 3
        
        if moreButtonSize != .zero {
            var height = twoLineText + Constanst.textInserts.bottom
            height += photoAttachmentFrame.size != CGSize.zero ? Constanst.profileViewHight / 2 : 0
            
            moreGradientSize = CGSize(width: cardViewWidth, height: height)
        }
        let moreGradientOrigin = CGPoint(x: Constanst.cardInserts.left, y: postLabelFrame.maxY - twoLineText)
        let moreGradientFrame = CGRect(origin: moreGradientOrigin, size: moreGradientSize)
        
        let lastPoint = twoLineText / moreGradientFrame.height
        let locationGradient:[NSNumber] = [0, NSNumber(value: lastPoint)]
        
        
        // MARK: Работа с bottomFrame и position postLabelFrame
        
        var bottomViewTop:CGFloat = Constanst.cardInserts.left
        
        // Если есть фото то перенести профиль вниз
        if !(photoAttachmentFrame.size == CGSize.zero && postLabelFrame.size != .zero) {
            bottomViewTop = max(photoAttachmentFrame.maxY, postLabelFrame.maxY, moreButtonFrame.maxY)
        }
        let bottomFrame = CGRect(origin: CGPoint(x: Constanst.cardInserts.top, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constanst.profileViewHight))
        
        
        // MARK: Total Height
        
        let maxY = max(photoAttachmentFrame.maxY, postLabelFrame.maxY + Constanst.textInserts.bottom, moreButtonFrame.maxY, bottomFrame.maxY)
        
        let totalHeight = maxY + Constanst.cardInserts.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: photoAttachmentFrame,
                     profileViewFrame: bottomFrame,
                     moreButtonFrame: moreButtonFrame,
                     moreGradientView: moreGradientFrame, locationGradient: locationGradient,
                     totalHeight: totalHeight)
    }
    
    
    
}
