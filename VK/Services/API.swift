//
//  API.swift
//  VK
//
//  Created by Сергей Насыбуллин on 19.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    static let httpVersion = "HTTP/1.1"
    
    static let patch = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
