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
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    
    func wakeUpSession() {
        
        let scope = [VK_PER_OFFLINE]
        
        VKSdk.wakeUpSession(scope) { [delegate] (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            default:
                delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    
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
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}
