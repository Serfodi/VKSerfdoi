//
//  UserResponse.swift
//  VK
//
//  Created by Сергей Насыбуллин on 07.10.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
