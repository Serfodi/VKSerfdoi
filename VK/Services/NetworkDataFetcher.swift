//
//  NetworkDataFetcher.swift
//  VK
//
//  Created by Сергей Насыбуллин on 21.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?)->Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
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
