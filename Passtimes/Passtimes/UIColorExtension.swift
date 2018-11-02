//
//  UIColorExtension.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/1/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

extension UIColor {

    enum GradientDirection: Int {
        case topToBottom
        case leftToRight
        case bottomToTop
        case rightToLeft
        case topLeftToBottomRight
        case topRightToBottomLeft
        case bottomLeftToTopRight
        case bottomRightToTopLeft
    }

    class func gradientColor(view: UIView, colors: [CGColor], direction: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientDirection(gradient: gradientLayer, direction: direction)
        view.layer.addSublayer(gradientLayer)
    }

    class func gradientDirection(gradient: CAGradientLayer, direction: GradientDirection) {
        switch direction.rawValue {
        case GradientDirection.topToBottom.rawValue:
            gradient.startPoint = CGPoint(x: 0.5, y:0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case GradientDirection.bottomToTop.rawValue:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        case GradientDirection.leftToRight.rawValue:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case GradientDirection.rightToLeft.rawValue:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case GradientDirection.topLeftToBottomRight.rawValue:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        case GradientDirection.topRightToBottomLeft.rawValue:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        case GradientDirection.bottomLeftToTopRight.rawValue:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        case GradientDirection.bottomRightToTopLeft.rawValue:
            gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        default:    // Default to TopToBottom
            gradient.startPoint = CGPoint(x: 0.5, y:0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }

}
