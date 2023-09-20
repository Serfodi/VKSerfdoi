//
//  AuthService.swift
//  VK
//
//  Created by Сергей Насыбуллин on 04/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}


class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    private let appId = "51752378"
    private let vkSdk:VKSdk
    
    weak var delegate:AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    
    func wakeUpSession() {
//        let scope = [VK_PER_OFFLINE]
        let scope = ["wall", "friends"]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            } else {
                print("auth problems, state \(state) error \(String(describing: error))")
                delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    
    func logoutSession() {
        VKSdk.forceLogout()
    }
    
    
    
    // MARK: VKSdkDelegate
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceDidSignInFail()
    }
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        print(#function)
    }
    
    func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        if let newToken = newToken {
            print("newToken: \(newToken)")
            newToken.save(toDefaults: "token")
        }
        if let oldToken = oldToken {
            UserDefaults.standard.removeObject(forKey: "token")
            print("oldToken: \(oldToken)")
        }
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    // MARK: VkSdkUIDelegate
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController!) {
        print(#function)
    }
    
    func vkSdkDidDismiss(_ controller: UIViewController!) {
        print(#function)
    }
    
}
