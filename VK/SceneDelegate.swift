//
//  SceneDelegate.swift
//  VK
//
//  Created by Сергей Насыбуллин on 03/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit
import VKSdkFramework


class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {
    
    var window: UIWindow?
    var authService: AuthService!

    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sd: SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
        return sd 
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        authService = AuthService()
        authService.delegate = self
        
        let authVC = UIStoryboard(name: String(describing: AuthViewController.self), bundle: nil).instantiateInitialViewController() as? AuthViewController
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


    // MARK: -AuthServiceDelegate
    
    func authServiceShouldShow(_ viewConroller: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewConroller, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print(#function)
        
        /*
        let feedVC = UIStoryboard(name: String(describing: NewsfeedViewController.self), bundle: nil).instantiateInitialViewController() as! NewsfeedViewController
        let navVC = UINavigationController(rootViewController: feedVC)
        let chatVC = ChatViewController()
        let navChatVC =  UINavigationController(rootViewController: chatVC)
        let tabVC = UITabBarController()
        tabVC.viewControllers = [navVC, chatVC]
        
        */
        
        window?.rootViewController = TabBarController()
    }
    
    func authServiceDidSignInFail() {
         print(#function)
    }
}

