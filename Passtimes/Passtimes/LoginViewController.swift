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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Up view
        viewSetUp()
    }

    func viewSetUp() {
        // Login button with round corners
        loginButton.roundedCorners(radius: 10)
        loginButton.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)

        // ActivityIndicator
        activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [#colorLiteral(red: 0.9257785678, green: 0.1494095027, blue: 0.3405916691, alpha: 1)]

        // Anchor to center
        activityIndicator.center = view.center
        // Add activityIndicator to view
        self.view.addSubview(activityIndicator)

        hideKeyboardWhenTappedAround()

        email.inputAccessoryView = toolbarAccessoryView()
        password.inputAccessoryView = toolbarAccessoryView()
    }

    @IBAction func login(_ sender: Any) {
        if let email = email.text, !email.isEmpty, let password = password.text, !password.isEmpty {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false

            AuthUtils.signInWithEmailAndPassword(email: email, password: password) { (success) in
                // Dismiss activityIndicator
                self.activityIndicator.stopAnimating()
                if(success) {
                   self.performSegue(withIdentifier: "unwindToNavigation", sender: nil)
                } else {
                    SnackbarUtils.snackbarMake(message: "Please make sure to enter correct email and password", title: nil)
                }

                self.view.isUserInteractionEnabled = false
            }
        }
    }

}
