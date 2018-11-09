//
//  AnimationUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/9/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class AnimationUtils {

    public static func shakeAnimation(view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true

        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 5, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 5, y: view.center.y))

        view.layer.add(animation, forKey: "position")
    }

}
