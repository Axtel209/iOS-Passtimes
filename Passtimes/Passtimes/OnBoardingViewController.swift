//
//  OnBoardingViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {

    /* IBOlets */
    @IBOutlet var onboardingView: OnboardingPage!
    @IBOutlet var loginButton: UIButton!

    /* Member Variables */

    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingView.delegate = self
        onboardingView.dataSource = self

        loginButton.roundedCorners(radius: 10)
        loginButton.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    func onboardingItemsCount() -> Int {
        return 3
    }

    func onboardingItem(at index: Int) -> OnboardingItemInfo {

        let redColor = UIColor.init(red: 217.0/255.0, green: 61.0/255.0, blue: 90.0/255.0, alpha: 1.0)

        let font = UIFont(name: "AvenirNext-Bold", size: 18)

        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_one"),
                               title: "Connect with the Community",
                               description: "Meet up with new people or friends by attending or creating events.",
                               pageIcon: UIImage(),
                               color: UIColor.clear,
                               titleColor: redColor,
                               descriptionColor: UIColor.black,
                               titleFont: font!,
                               descriptionFont: font!),

            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_two"),
                               title: "Earn achivements and points",
                               description: "Receive points and compete with other players and friends.",
                               pageIcon: UIImage(),
                               color: UIColor.clear,
                               titleColor: redColor,
                               descriptionColor: UIColor.black,
                               titleFont: font!,
                               descriptionFont: font!),

            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "onboarding_three"),
                               title: "Build your own profile",
                               description: "Have your own player card with your achiviements, points and past events.",
                               pageIcon: UIImage(),
                               color: UIColor.clear,
                               titleColor: redColor,
                               descriptionColor: UIColor.black,
                               titleFont: font!,
                               descriptionFont: font!)
            ][index]
    }

    func onboardingWillTransitonToIndex(_: Int) {
        
    }

    func onboardingDidTransitonToIndex(_: Int) {

    }

    @IBAction func moveToNextViewController(_ sender: Any) {
        if let button = sender as? UIButton {
            if (button.tag == 0) {
                performSegue(withIdentifier: "toLogin", sender: nil)
            } else {
                performSegue(withIdentifier: "toSignUp", sender: nil)
            }
        }
    }

}
