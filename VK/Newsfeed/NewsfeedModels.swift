//
//  NewsfeedModels.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

enum Newsfeed {
    // MARK: Use cases
    
    enum Something {
        struct Request {
            enum RequestType {
                case getNewsfeed
                case revealPostId(postId: Int)
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsfeed(feed: FeedResponse, revealidPostId: [Int])
            }
        }
        struct ViewModel {
            enum ViewModelType {
                case displayNewsfeed(feedViewModel: FeedViewModel)
            }
        }
    }
}

struct FeedViewModel {
    
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconImageString: String
        var name: String
        var date: String
        var post: String?
        var photoAttachement: FeedCellPhotoAttachementViewModel?
        var sizes: FeedCellSizes
    }
    
    struct FeedCellphotoAttachment: FeedCellPhotoAttachementViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
