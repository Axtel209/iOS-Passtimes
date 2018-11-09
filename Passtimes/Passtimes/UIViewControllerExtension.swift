//
//  UIViewControllerExtension.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/8/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

extension UIViewController {

    func toolbarAccessoryView() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(UIViewController.dismissKeyboard))

        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.sizeToFit()

        return toolbar
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
