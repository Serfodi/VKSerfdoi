//
//  AuthViewController.swift
//  VK
//
//  Created by Сергей Насыбуллин on 03/09/2020.
//  Copyright © 2020 NasybullinSergei. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    
    
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
    }

    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
    
    @IBAction func logOutTouch(_ sender: UIButton) {
        authService.logoutSession()
    }
}

