//
//  OnGoingCollectionViewCell.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class OnGoingCollectionViewCell: UICollectionViewCell {

    /* Outlets */
    @IBOutlet var card: UIView!
    @IBOutlet var sport: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var attendingIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell cornerRadius and shadow
        self.card.layer.cornerRadius = 10
        self.card.layer.masksToBounds = true

        // Draw topRight and bottomLeft corner radius to attending indicator
        let path = UIBezierPath(roundedRect:self.attendingIndicator.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))

        // Apply mask with custom path
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.attendingIndicator.layer.mask = maskLayer

        // Draw showdow to cell
        self.backgroundColor = UIColor.clear
        self.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    // Populate cell data
    public func configureCell(with event: Event) {
        self.sport.text = event.sport
        self.title.text = event.title
        self.location.text = event.location
        self.time.text = CalendarUtils.getTimeFromDateTimestamp(event.startDate)
        self.month.text = CalendarUtils.getMonthFromDateTimestamp(event.startDate)
        self.day.text = CalendarUtils.getDayFromDateTimestamp(event.startDate)
    }

}
