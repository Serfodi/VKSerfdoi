//
//  NetworkDataFetcher.swift
//  VK
//
//  Created by Сергей Насыбуллин on 21.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?)->Void)
    func getUser(response: @escaping (UserResponse?)->Void)
}

struct NetworkDataFetcher: DataFetcher {
   
    let networking: Networking
    private let authService: AuthService
    
    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId , "fields": "photo_100"]
        networking.request(patch: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decoderJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
        
    }
    
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        
        networking.request(patch: API.patch, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoder = self.decoderJSON(type: FeedResponseWrapped.self, from: data)
            response(decoder?.response)
        }
    }
    
    
    private func decoderJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard
            let data = from,
            let response = try? decoder.decode(type.self, from: data)
        else { return nil }
        return response
    }
    
    
    
}
