//
//  FeedViewController.swift
//  VK
//
//  Created by Сергей Насыбуллин on 04/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let networkService: NetworkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let params = ["filters": "post, photo"]
        networkService.request(patch: API.patch, params: params) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
            }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data)
            print("json: \(json)")
        }
    }
    
}

