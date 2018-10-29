//
//  SignUpViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/26/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    /* Outlets */
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var signUp: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Up view
        viewSetUp()
    }

    func viewSetUp() {
        self.signUp.roundedCorners(radius: 10)
        self.signUp.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)

        self.photo.roundedCorners(radius: photo.frame.size.height / 2)
    }

    @IBAction func signUp(_ sender: Any) {
        // Valiate textfields
        if let name = name.text, !name.isEmpty, let email = email.text, !email.isEmpty, let password = password.text, !password.isEmpty, let confirmPassword = confirmPassword.text {
            if !ValidationUtils.isValid(email: email) { return }
            if !ValidationUtils.isValid(password: password) { return }
            if !ValidationUtils.isValid(password: password, confirm: confirmPassword) { return }

            //guard let imageData = photo.image?.pngData() else { return }
            guard let data = photo.image?.jpegData(compressionQuality: 1) else { return }

            // Start a loading indicator
            let activityIndicator = ActivityIndicatorUtils.activityIndicatorMake(view: self.view)
            activityIndicator.startAnimating()
            self.signUp.isEnabled = false
            // SignUp user and perform segue after completion
            AuthUtils.signUpwithEmailAndPassword(email: email, password: password, name: name, photo: data) { (success) in
                activityIndicator.stopAnimating()

                if success {
                    self.performSegue(withIdentifier: "toFavorite", sender: nil)
                }
                
                self.signUp.isEnabled = true
            }

        } else {
            // TODO: Toast for empty fields
            SnackbarUtils.snackbarMake(message: "One or more fields are empty", title: nil)
        }
    }

    @IBAction func editImage() {
        ImagePickerUtils().pickImage(self) { (chosenImage) in
            self.photo.image = chosenImage
        }
    }

}
