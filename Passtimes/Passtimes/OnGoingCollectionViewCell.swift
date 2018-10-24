//
//  OnGoingCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class OnGoingCollectionViewCell: UICollectionViewCell {

    @IBOutlet var sport: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var attendingIndicator: UIView!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configure() {
    }

}
