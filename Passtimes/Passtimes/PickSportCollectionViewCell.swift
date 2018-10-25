//
//  PickSportCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class PickSportCollectionViewCell: UICollectionViewCell {

    @IBOutlet var card: UIView!
    @IBOutlet var sportIcon: UIImageView!
    @IBOutlet var category: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell cornerRadius and shadow
    }

    // Populate cell data
    public func configureCell(with sport: Sport, isActive: Bool) {
        if(isActive) {
            sportActive(url: sport.active)
        } else {
            sportIdle(url: sport.idle)
        }

        self.category.text = sport.category
    }

    public func sportActive(url: String) {
        // Card border active
        self.card.layer.borderWidth = 3
        self.card.layer.borderColor = #colorLiteral(red: 0.08800473064, green: 0.808358252, blue: 0.7374972701, alpha: 1)

        self.sportIcon.kf.setImage(with: URL(string: url))

        self.category.textColor = #colorLiteral(red: 0.08800473064, green: 0.808358252, blue: 0.7374972701, alpha: 1)
    }

    public func sportIdle(url: String) {
        // Card Border idle
        self.card.layer.borderWidth = 0
        self.card.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)

        self.sportIcon.kf.setImage(with: URL(string: url))

        self.category.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }
    
}
