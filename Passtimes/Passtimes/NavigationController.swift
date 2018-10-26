//
//  NavigationController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class NavigationController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show login view if not currently logged in
        let auth = AuthUtils.sharedInstance
        // TODO: DELETE SIGNOUT
        //auth.signOut()
        if (!auth.isUserCurrentlySignedIn()){
            perform(#selector(showOnBoardingController), with: nil, afterDelay: 0.01)
        }
    }

    @objc func showOnBoardingController() {
        if let loginVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
            present(loginVC, animated: true, completion: nil)
        }
//        if let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//            present(loginVC, animated: true, completion: nil)
//        }
    }

    @IBAction func unwindToNavigation(segue:UIStoryboardSegue) { }

}
