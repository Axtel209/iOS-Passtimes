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

        
        let path = UIBezierPath(roundedRect:self.attendingIndicator.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft],
                                cornerRadii: CGSize(width: 10, height:  10))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.attendingIndicator.layer.mask = maskLayer

        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width:0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.2
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
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
