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
    
    let dateFormator: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    // MARK: Do something
    
    func presentSomething(response: Newsfeed.Something.Response.ResponseType) {
        switch response {
        case .presentNewsfeed(let feed):
            
            // Подготовка даты для отображения
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displaySomething(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        }
    }
    
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profiles], groups: [Groups]) -> FeedViewModel.Cell {
        let profile = self.profile(for: feedItem.sourceId, profile: profiles, groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormator.string(from: date)
        return FeedViewModel.Cell.init(iconImageString: profile.photo,
                                       name: profile.name,
                                date: dateTitle,
                                post: feedItem.text)
    }
    
    private func profile(for sourseId: Int, profile: [Profiles], groups: [Groups]) -> ProfileRepresenatable {
        let profileOrGroups: [ProfileRepresenatable] = sourseId >= 0 ? profile : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresentable = profileOrGroups.first { (myProfileRepresentable) in
            myProfileRepresentable.id == normalSourseId
        }
        return profileRepresentable!
    }
    
}
