//
//  RankingListCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/7/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class RankingListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var playerCard: UIView!
    @IBOutlet var rank: UILabel!
    @IBOutlet var playerPhoto: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var xp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.playerCard.roundedCorners(radius: 10)
        self.playerPhoto.roundedCorners(radius: self.playerPhoto.frame.height / 2)

        self.backgroundColor = UIColor.clear
        self.playerCard.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    func configure(player: Player, rank: Int) {
        self.rank.text = String(rank)
        self.playerPhoto.kf.setImage(with: URL(string: player.thumbnail))
        self.name.text = player.name
        self.xp.text = String(player.overallXP)
    }
}
