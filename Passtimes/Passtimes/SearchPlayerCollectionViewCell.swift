//
//  SearchPlayerCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/18/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class SearchPlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var card: UIView!
    @IBOutlet var playerPhoto: UIImageView!
    @IBOutlet var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.card.roundedCorners(radius: 10)
        self.playerPhoto.roundedCorners(radius: self.playerPhoto.frame.height / 2)

        self.backgroundColor = UIColor.clear
        self.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    func configureCell(with player: Player) {
        playerPhoto.kf.setImage(with: URL(string: player.thumbnail))
        name.text = player.name
    }

}
