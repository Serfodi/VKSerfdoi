//
//  NetworkService.swift
//  VK
//
//  Created by Сергей Насыбуллин on 19.09.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import Foundation

protocol Networking {
    func request(patch: String, params: [String: String], complition: @escaping (Data?, Error?) -> Void)
}


final class NetworkService: Networking {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(patch: String, params: [String : String], complition: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = self.url(from: patch, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, complition: complition)
        task.resume()
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data,error )
            }
        }
    }
    
    private func url(from path: String, params: [String:String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.patch
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
    
}
