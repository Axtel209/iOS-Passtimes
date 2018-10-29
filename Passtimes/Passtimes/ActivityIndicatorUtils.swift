//
//  ActivityIndicatorUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/26/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialActivityIndicator

class ActivityIndicatorUtils {

    public static func activityIndicatorMake(view: UIView) -> MDCActivityIndicator {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [#colorLiteral(red: 0.9257785678, green: 0.1494095027, blue: 0.3405916691, alpha: 1)]

        // Anchor to center
        activityIndicator.center = view.center

        view.addSubview(activityIndicator)
        return activityIndicator
    }

}
