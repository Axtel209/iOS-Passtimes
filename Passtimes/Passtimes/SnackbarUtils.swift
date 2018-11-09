//
//  SnackbarUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialSnackbar

class SnackbarUtils {

    // Create snackbar with or without action
    public static func snackbarMake(message: String, title: String?) {
        let manager = MDCSnackbarManager()
        let snackbarMessage = MDCSnackbarMessage()
        snackbarMessage.text = message
        snackbarMessage.duration = 3
        // Show action if it has one
        if let title = title {
            let action = MDCSnackbarMessageAction()
            action.title = title
            snackbarMessage.action = action
        }
        manager.show(snackbarMessage)
    }

}
