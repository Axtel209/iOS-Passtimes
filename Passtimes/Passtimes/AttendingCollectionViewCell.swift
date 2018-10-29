//
//  AttendingCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/28/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class AttendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet var card: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var sportIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell cornerRadius and shadow
        self.card.layer.cornerRadius = 10
        self.card.layer.masksToBounds = true

        // Draw showdow to cell
        self.backgroundColor = UIColor.clear
        self.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    func configureCell(with event: Event) {
        title.text = event.title
        date.text = CalendarUtils.getTimeFromDateTimestamp(event.startDate)
        sportIcon.kf.setImage(with: URL(string: event.sportThumbnail))
    }

}
