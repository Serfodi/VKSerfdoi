//
//  FeedViewController.swift
//  VK
//
//  Created by Сергей Насыбуллин on 04/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            
            feedResponse.items.map { (feedItem) in
                print(feedItem.date)
            }
        }
        
        
        
        
    }
    
}

