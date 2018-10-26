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
    public static func snackbarMake(message: String, snackbarAction: MDCSnackbarMessageAction?, title: String?) {
        let manager = MDCSnackbarManager()
        let snackbarMessage = MDCSnackbarMessage()
        snackbarMessage.text = message
        // Show action if it has one
        if let action = snackbarAction, let title = title {
            MDCSnackbarMessageActionHandler
            //action.handler =
            action.title = title
            snackbarMessage.action = action
        }
        manager.show(snackbarMessage)
    }

}
