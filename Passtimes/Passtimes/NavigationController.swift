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

        //auth.signOut()
//        if (!AuthUtils.isUserCurrentlySignedIn()){
//            perform(#selector(showOnBoardingController), with: nil, afterDelay: 0.01)
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if !AuthUtils.isUserCurrentlySignedIn() {
            if let loginVC = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
                present(loginVC, animated: true, completion: nil)
            }
        }
    }

    @objc func showOnBoardingController() {
        if let onboarding = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
            present(onboarding, animated: true, completion: nil)
        }
    }

    @IBAction func unwindToNavigation(segue:UIStoryboardSegue) { }

}
