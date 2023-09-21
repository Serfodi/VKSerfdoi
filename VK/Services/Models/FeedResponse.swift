//
//  FeedResponse.swift
//  VK
//
//  Created by Сергей Насыбуллин on 21.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
}

struct CountableItem: Decodable {
    let count: Int
}
