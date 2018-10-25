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
