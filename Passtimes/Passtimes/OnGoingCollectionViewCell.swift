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

    public func isAttending(_ bool: Bool) {
        if bool {
            self.attendingIndicator.backgroundColor = #colorLiteral(red: 0.08800473064, green: 0.808358252, blue: 0.7374972701, alpha: 1)
            self.month.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.day.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.attendingIndicator.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            self.month.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.1490196078, alpha: 1)
            self.day.textColor = #colorLiteral(red: 0.1333333333, green: 0.1294117647, blue: 0.1490196078, alpha: 1)
        }
    }



}
