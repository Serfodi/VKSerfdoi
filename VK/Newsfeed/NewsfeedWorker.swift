//
//  NewsfeedWorker.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

class NewsfeedWorker {
    
    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    private var revealedPostId = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
 
    func getUser(complition: @escaping (UserResponse?)->Void) {
        fetcher.getUser { (userResponse) in
            complition(userResponse)
     
        }
    }
    
    func getFeed(complition: @escaping ([Int], FeedResponse)->Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] (feed) in
            self?.feedResponse = feed
            guard let feedResponse = self?.feedResponse else { return }
            complition(self!.revealedPostId, feedResponse)
        }
    }
    
    func revealPostId(forPostId postId: Int ,complition: @escaping ([Int], FeedResponse)->Void) {
        revealedPostId.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        complition(revealedPostId, feedResponse)
    }
    
    // Обновляет посты от конца
    func getNextBatch(complition: @escaping ([Int], FeedResponse)->Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { (feed) in
            guard let feed = feed else { return }
            guard self.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self.feedResponse == nil {
                self.feedResponse = feed
            } else {
                self.feedResponse?.items.append(contentsOf: feed.items)
                self.feedResponse?.nextFrom = feed.nextFrom
                
                var profile = feed.profiles
                if let oldProfiles = self.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { oldProfile in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    profile.append(contentsOf: oldProfilesFiltered)
                }
                self.feedResponse?.profiles = profile
                
                var groups = feed.groups
                if let oldGroups = self.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { oldGroups in
                        !feed.groups.contains(where: { $0.id == oldGroups.id })
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self.feedResponse?.groups = groups
                
                
               
            }
            
            guard let feedResponse = self.feedResponse else { return }
            complition(self.revealedPostId, feedResponse)
        }
    }
    
    
}
