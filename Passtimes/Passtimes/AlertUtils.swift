//
//  AlertUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/7/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class AlertUtils {

    static func AlertMake(view: UIViewController, title: String, message: String, style: UIAlertController.Style, complition: ((Bool) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let possitiveAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if action.style == .default {
                complition!(true)
            }
        }
        let negativeAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            if action.style == .cancel {
                complition!(false)
            }
        }
        alert.addAction(possitiveAction)
        alert.addAction(negativeAction)
        view.present(alert, animated: true, completion: nil)
    }

}
