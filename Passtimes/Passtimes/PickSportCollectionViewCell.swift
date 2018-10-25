//
//  PickSportCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class PickSportCollectionViewCell: UICollectionViewCell {

    @IBOutlet var sportIcon: UIImageView!
    @IBOutlet var category: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell cornerRadius and shadow
    }

    // Populate cell data
    public func configureCell(with sport: Sport) {
        self.sportIcon.kf.setImage(with: URL(string: sport.idle))
        self.category.text = sport.category
    }
    
}
