//
//  NewsfeedInteractor.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func doSomething(request: Newsfeed.Something.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var worker: NewsfeedWorker?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    // MARK: Do something
    
    func doSomething(request: Newsfeed.Something.Request.RequestType) {
        switch request {
        case .getNewsfeed:
            fetcher.getFeed { [weak self] (feedResponse) in
                guard let feedResponse = feedResponse else { return }
                self?.presenter?.presentSomething(response: .presentNewsfeed(feed: feedResponse))
            }
        }
    }
    
}
