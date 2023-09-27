//
//  NewsfeedCellLayoutCalculator.swift
//  VK
//
//  Created by Сергей Насыбуллин on 23.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachementViewModel?) -> FeedCellSizes
}

final class NewsfeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }
    
    struct Sizes: FeedCellSizes {
        var bottomView: CGRect
        var totalHeight: CGFloat
        var postLabelFrame: CGRect
        var attachmentFramge: CGRect
    }
    
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachementViewModel?) -> FeedCellSizes {
        
        let cardViewWidth = screenWidth - Constanst.cardInserts.left - Constanst.cardInserts.right
        
        
        // MARK: Работа с photoAttachmentFrame
        
        var photoAttachmentFrame = CGRect.zero
        
        if let attechment = photoAttachment {
            let ration: CGFloat = CGFloat( Float(attechment.height) / Float(attechment.width) )
            photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ration)
        }
        
        
        // MARK: Работа с postLabelFrame
        
        let postTextTop = photoAttachmentFrame.size == CGSize.zero ? Constanst.postInserts.top : photoAttachmentFrame.maxY + Constanst.postInserts.top
        var postLabelFrame = CGRect(origin: CGPoint(x: Constanst.postInserts.left, y: postTextTop), size: .zero)
        
        
        if let text = postText, !text.isEmpty {
            let widht = cardViewWidth - Constanst.postInserts.left - Constanst.postInserts.right
            
            let height = text.height(widht: widht, fount: Constanst.postLabelFount!)
            
            postLabelFrame.size = CGSize(width: widht, height: height)
        }
        
        
        
        
        // MARK: Работа с bottomFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, photoAttachmentFrame.maxY )
        
        
        
        
        let bottomFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constanst.profileViewHight))
        
        let totalHeight = bottomFrame.maxY + Constanst.cardInserts.bottom
        
        return Sizes(bottomView: bottomFrame,
                     totalHeight: totalHeight,
              postLabelFrame: postLabelFrame,
                     attachmentFramge: photoAttachmentFrame)
    }
}
