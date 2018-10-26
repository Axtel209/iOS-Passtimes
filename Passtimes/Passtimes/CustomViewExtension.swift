//
//  CustomViewExtension.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialActivityIndicator

extension UIView {

    func roundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    // Draw shadow to view
    func drawShadow(offset: CGSize, radius: CGFloat, opacity: Float) {
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }

    func activityIndicator(colors: [UIColor]) -> MDCActivityIndicator {
        let activityIndicator = MDCActivityIndicator()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = colors

        // Anchor to center
        activityIndicator.center = self.center
        // Add activityIndicator to view
        self.addSubview(activityIndicator)

        return activityIndicator
    }

}
