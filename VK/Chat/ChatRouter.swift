//
//  ChatRouter.swift
//  VK
//
//  Created by Сергей Насыбуллин on 12.10.2023.
//  Copyright (c) 2023 NasybullinSergei. All rights reserved.
//

import UIKit

@objc protocol ChatRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol ChatDataPassing
{
  var dataStore: ChatDataStore? { get }
}

class ChatRouter: NSObject, ChatRoutingLogic, ChatDataPassing
{
  weak var viewController: ChatViewController?
  var dataStore: ChatDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: ChatViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: ChatDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
