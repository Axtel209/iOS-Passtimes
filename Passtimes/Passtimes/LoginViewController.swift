//
//  LoginViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.roundedCorners(radius: 10)
        loginButton.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
