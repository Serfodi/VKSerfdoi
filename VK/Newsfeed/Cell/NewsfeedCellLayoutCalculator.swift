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
        
        let cardViewWidth = screenWidth - Constanst.cardInserts.left - Constanst.cardInserts.right
        
        var showMoreButton = false
        
        
        // MARK: Photo Attachment Frame
        
        var photoAttachmentFrame = CGRect.zero
        
        // calculations size photoAttachment
        /*
        if let attechment = photoAttachment {
            let ration: CGFloat = CGFloat( Float(attechment.height) / Float(attechment.width) )
            photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ration)
        }
         */
        
        if let attechment = photoAttachments.first {
            let ration: CGFloat = CGFloat( Float(attechment.height) / Float(attechment.width) )
            
            if photoAttachments.count == 1 {
                photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ration)
            } else if photoAttachments.count > 1 {
                
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
            
            let widht = cardViewWidth - Constanst.postInserts.left - Constanst.postInserts.right
            var height = text.height(widht: widht, fount: Constanst.postLabelFount!)
            
            // Добовлять ли кнопку "more"
            let limitHeight = Constanst.postLabelFount!.lineHeight * Constanst.minifiedPostLimitLines
            if !isFullSizePost && height > limitHeight {
                height = Constanst.postLabelFount!.lineHeight * Constanst.minifiedPostLines
                showMoreButton = true
            }
            
            postLabelFrame.size = CGSize(width: widht, height: height)
            
            // calculations position postLabel
            let postTextTop = photoAttachmentFrame.size == CGSize.zero ? Constanst.profileViewHight : photoAttachmentFrame.maxY + Constanst.postInserts.top
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
        let center = (cardViewWidth - Constanst.moreTextButtonSize.width) / 2
        // for text label
        let morelextButtonOrigin = CGPoint(x: center, y: postLabelFrame.maxY + 6)
        let moreButtonFrame = CGRect(origin: morelextButtonOrigin, size: moreButtonSize)
        
        
        
        // MARK: Работа с bottomFrame и position postLabelFrame
        
        var bottomViewTop:CGFloat = 0
        
        // Если есть фото то перенести профиль вниз
        if !(photoAttachmentFrame.size == CGSize.zero && postLabelFrame.size != .zero) {
            bottomViewTop = max(photoAttachmentFrame.maxY, postLabelFrame.maxY, moreButtonFrame.maxY)
        }
        let bottomFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constanst.profileViewHight))
        
        
        // MARK: Total Height
        
        let maxY = max(photoAttachmentFrame.maxY, postLabelFrame.maxY + Constanst.postInserts.bottom, moreButtonFrame.maxY, bottomFrame.maxY)
        
        let totalHeight = maxY + Constanst.cardInserts.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: photoAttachmentFrame,
                     profileViewFrame: bottomFrame,
                     moreButtonFrame: moreButtonFrame,
                     totalHeight: totalHeight)
    }
    
    
    
}
