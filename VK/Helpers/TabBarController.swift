//
//  TabBarController.swift
//  VK
//
//  Created by Сергей Насыбуллин on 14.10.2023.
//  Copyright © 2023 NasybullinSergei. All rights reserved.
//

import UIKit


final class TabBarController: UITabBarController {
    
    private enum TabBarItem: Int {
        case feed
        case chat
        case profile
        
        var iconName: String {
            switch self {
            case .feed:
                return "house"
            case .chat:
                return "message"
            case .profile:
                return "person.crop.circle"
            }
        }
        
        var name: String {
            switch self {
            case .feed:
                return "House"
            case .chat:
                return "Message"
            case .profile:
                return "Profile"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    

    private func setupTabBar() {
        let dataSoure: [TabBarItem] = [.feed, .chat]
        
        self.viewControllers = dataSoure.map {
            switch $0 {
            case .feed:
                let feedVC = UIStoryboard(name: String(describing: NewsfeedViewController.self), bundle: nil).instantiateInitialViewController() as! NewsfeedViewController
                return wrappedInNavigationController(with: feedVC)
            case .chat:
                let chatVC = ChatViewController()
                return wrappedInNavigationController(with: chatVC)
            case .profile:
                let prifileVC = ChatViewController()
                return wrappedInNavigationController(with: prifileVC)
            }
        }
        
        // MARK: Tab Bar Appearance
        
        tabBar.tintColor = Constanst.secondColor
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.image = UIImage(systemName: dataSoure[$0].iconName)
            $1.tabBarItem.title = dataSoure[$0].name
//            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
                
        let app = UITabBarAppearance()
        app.backgroundEffect = .none
        app.shadowColor = .clear
        tabBar.standardAppearance = app
        
        let blure = BlurGradientView()
        blure.locationsGradient = [0, 0.4]
        
        let size = CGSize(width: tabBar.frame.width, height: tabBar.frame.height * 1.5)
        let origin = CGPoint(x: 0, y: -tabBar.frame.height * 0.5)
        
        blure.frame = CGRect(origin: origin, size: size)
        
        tabBar.insertSubview(blure, at: 0)
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any? = "") -> UINavigationController {
        UINavigationController(rootViewController: with)
    }
    
}
