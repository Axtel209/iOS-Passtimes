//
//  LoginViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class LoginViewController: UIViewController {

    /* IBOutlet */
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!

    /* Member Variables */
    var activityIndicator: MDCActivityIndicator!
    var auth: AuthUtils!


    override func viewDidLoad() {
        super.viewDidLoad()

        auth = AuthUtils.sharedInstance

        loginButton.roundedCorners(radius: 10)
        loginButton.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)

        activityIndicatorSetUp()
    }

    func activityIndicatorSetUp() {
        activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [#colorLiteral(red: 0.9257785678, green: 0.1494095027, blue: 0.3405916691, alpha: 1)]

        // Anchor to center
        activityIndicator.center = view.center
        // Add activityIndicator to view
        self.view.addSubview(activityIndicator)
    }

    @IBAction func login(_ sender: Any) {
        if let email = email.text, !email.isEmpty, let password = password.text, !password.isEmpty {
            self.activityIndicator.startAnimating()

            auth.signInWithEmailAndPassword(email: email, password: password) {
                // Dismiss activityIndicator
                self.activityIndicator.stopAnimating()
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "unwindToNavigation", sender: nil)
            }
        }
    }

}
