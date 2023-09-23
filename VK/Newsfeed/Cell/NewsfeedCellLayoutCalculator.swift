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

struct Constanst {
    static let cardInserts = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    static let topViewHight: CGFloat = 40
    static let postInserts = UIEdgeInsets(top: 10 + topViewHight + 5, left: 10, bottom: 5, right: 10)
    static let postLabelFount = UIFont.systemFont(ofSize: 15)
    static let bottomViewHight: CGFloat = 36
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
        
        // MARK: Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constanst.postInserts.left, y: Constanst.postInserts.top),
                                    size: .zero)
        
        if let text = postText, !text.isEmpty {
            let widht = cardViewWidth - Constanst.postInserts.left - Constanst.postInserts.right
            let height = text.height(widht: widht, fount: Constanst.postLabelFount)
            
            postLabelFrame.size = CGSize(width: widht, height: height)
        }
        
        // MARK: Работа с photoAttachmentFrame
        
        let attechmentTop = postLabelFrame.size == CGSize.zero ? Constanst.postInserts.top : postLabelFrame.maxY + Constanst.postInserts.bottom
        var photoAttachmentFrame = CGRect(origin: CGPoint(x: 0, y: attechmentTop),
                                    size: .zero)
        
        if let attechment = photoAttachment {
            let ration: CGFloat = CGFloat( Float(attechment.height) / Float(attechment.width) )
            photoAttachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ration)
        }
        
        // MARK: Работа с bottomFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, photoAttachmentFrame.maxY )
        let bottomFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                 size: CGSize(width: cardViewWidth, height: Constanst.bottomViewHight))
        
        let totalHeight = bottomFrame.maxY + Constanst.cardInserts.bottom
        
        return Sizes(bottomView: bottomFrame,
                     totalHeight: totalHeight,
              postLabelFrame: postLabelFrame,
                     attachmentFramge: photoAttachmentFrame)
    }
}
