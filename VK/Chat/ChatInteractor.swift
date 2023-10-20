//
//  ChatInteractor.swift
//  VK
//
//  Created by Сергей Насыбуллин on 12.10.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

protocol ChatBusinessLogic
{
  func doSomething(request: Chat.Something.Request)
}

protocol ChatDataStore
{
  //var name: String { get set }
}

class ChatInteractor: ChatBusinessLogic, ChatDataStore
{
  var presenter: ChatPresentationLogic?
  var worker: ChatWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Chat.Something.Request)
  {
    worker = ChatWorker()
    worker?.doSomeWork()
    
    let response = Chat.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
