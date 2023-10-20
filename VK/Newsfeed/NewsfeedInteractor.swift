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
    
    // MARK: Do something
    
    func doSomething(request: Newsfeed.Something.Request.RequestType) {
        if worker == nil {
            worker = NewsfeedWorker()
        }
        
        switch request {
        case .getNewsfeed:
            worker?.getFeed(complition: { [weak self] (revealedPostId, feed) in
                self?.presenter?.presentSomething(response: .presentNewsfeed(feed: feed, revealidPostId: revealedPostId))
            })
        case .revealPostId(postId: let postId):
            worker?.revealPostId(forPostId: postId, complition: { [weak self] (revealedPostId, feed) in
                self?.presenter?.presentSomething(response: .presentNewsfeed(feed: feed, revealidPostId: revealedPostId))
            })
        case .getUser:
            worker?.getUser(complition: { [weak self] (user) in
                self?.presenter?.presentSomething(response: .presentUserInfo(user: user))
            })
        case .getNextBatch:
            self.presenter?.presentSomething(response: .presentFooterLoader)
            worker?.getNextBatch(complition: { [weak self] (revealedPostId, feed) in
                self?.presenter?.presentSomething(response: .presentNewsfeed(feed: feed, revealidPostId: revealedPostId))
            })
        }
        
    }
    
}
