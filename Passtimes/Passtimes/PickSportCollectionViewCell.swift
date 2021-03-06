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

    var isActive: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell cornerRadius and shadow
        self.card.roundedCorners(radius: 10)

        // Draw shadow to cell
        self.backgroundColor = UIColor.clear
        self.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    // Populate cell data
    public func configureCell(with sport: Sport) {
        if(self.isActive) {
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
