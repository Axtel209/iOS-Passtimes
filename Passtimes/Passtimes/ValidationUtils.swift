//
//  ValidationUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/26/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation

class ValidationUtils {

    /* Any tipe of validation goes here */
    public static func isValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !predicate.evaluate(with: email) {
            SnackbarUtils.snackbarMake(message: "Email address badly formatted", title: nil)
        }
        return predicate.evaluate(with: email)
    }

    public static func isValid(password: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        if !predicate.evaluate(with: password) {
            SnackbarUtils.snackbarMake(message: "Password badly formatted", title: nil)
        }
        return predicate.evaluate(with: password)
    }

    public static func isValid(password: String, confirm: String) -> Bool {
        if password != confirm {
            SnackbarUtils.snackbarMake(message: "Passwords don't match", title: nil)
        }
        return password == confirm
    }
}
