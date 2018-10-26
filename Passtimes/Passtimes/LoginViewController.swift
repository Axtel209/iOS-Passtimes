//
//  LoginViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    /* IBOutlet */
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    

    /* Member Variables */
    var auth: AuthUtils!

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = AuthUtils.sharedInstance

        loginButton.roundedCorners(radius: 10)
        loginButton.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    @IBAction func login(_ sender: Any) {
        if let email = email.text, !email.isEmpty, let password = password.text, !password.isEmpty {
            auth.signInWithEmailAndPassword(email: email, password: password) {
                // TODO: dismiss loading

            }
        }
    }

}
