//
//  NewsfeedPresenter.swift
//  VK
//
//  Created by Сергей Насыбуллин on 22.09.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentSomething(response: Newsfeed.Something.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    
    var celllayoutCalculator: FeedCellLayoutCalculatorProtocol = NewsfeedCellLayoutCalculator(screenWidth: UIScreen.main.bounds.width)
    
    let dateFormator: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    // MARK: Do something
    
    func presentSomething(response: Newsfeed.Something.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed, let revealdedPostIds):
            
            print(revealdedPostIds)
            
            // Подготовка даты для отображения
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealdedPostIds: revealdedPostIds)
            }
            
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsfeed cells count", comment: ""), cells.count)
            
            
            let feedViewModel = FeedViewModel(cells: cells, footerTitle: footerTitle)
            viewController?.displaySomething(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel(photoUrlString: user?.photo100)
            viewController?.displaySomething(viewModel: .displayUser(userViewModel: userViewModel))
        case .presentFooterLoader:
            viewController?.displaySomething(viewModel: .displayFooterLoader)
        }
    }
    
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profiles], groups: [Groups], revealdedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profile: profiles, groups: groups)
        
        let photoAttechments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormator.string(from: date)
        
        let isFullSizePost = revealdedPostIds.contains { (postId) in
            postId == feedItem.postId
        }
        
        // Вычисления расположения элементов
        let sizes = celllayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttechments, isFullSizePost: isFullSizePost)
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconImageString:  profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       post: feedItem.text,
                                       photoAttachements: photoAttechments,
                                       sizes: sizes)
    }
    
    private func profile(for sourseId: Int, profile: [Profiles], groups: [Groups]) -> ProfileRepresenatable {
        let profileOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profile : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresentable = profileOrGroups.first { (myProfileRepresentable) in
            myProfileRepresentable.id == normalSourseId
        }
        return profileRepresentable!
    }
    
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellphotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ (attechment) in
            attechment.photo
        }), let firstPhoto = photos.first else { return nil }
        return FeedViewModel.FeedCellphotoAttachment.init(photoUrlString: firstPhoto.srcBig, width: firstPhoto.width, height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellphotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap({ (attechment) in
            guard let photo = attechment.photo else { return nil }
            return FeedViewModel.FeedCellphotoAttachment(photoUrlString: photo.srcBig, width: photo.width, height: photo.height)
        })
    }
    
    
}
