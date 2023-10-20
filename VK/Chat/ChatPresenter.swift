//
//  ChatPresenter.swift
//  VK
//
//  Created by Сергей Насыбуллин on 12.10.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol ChatPresentationLogic
{
  func presentSomething(response: Chat.Something.Response)
}

class ChatPresenter: ChatPresentationLogic
{
  weak var viewController: ChatDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Chat.Something.Response)
  {
    let viewModel = Chat.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
