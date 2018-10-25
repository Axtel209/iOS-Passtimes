//
//  DetailEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class DetailEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var hostImage: UIImageView!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!

    /* Member Variables */
    var eventId: String?
    //var event: Event?
    var mDb: DatabaseUtils!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Validate for eventId
        if let eventId = eventId {
            // Read event document from Firestore
            mDb = DatabaseUtils.sharedInstance
            mDb.readDocument(from: .events, reference: eventId, returning: Event.self) { (object) in
                self.populateDetailView(with: object)
            }
        } else {
            // TODO: Chould not load event
        }
    }

    func populateDetailView(with event: Event) {
        // Set imageView round and Download image and
        hostImage.roundedCorners(radius: hostImage.frame.size.height / 2)
        hostImage.kf.setImage(with: URL(string: event.hostThumbnail))
        month.text = CalendarUtils.getMonthFromDateTimestamp(event.startDate)
        day.text = CalendarUtils.getDayFromDateTimestamp(event.startDate)
        eventTitle.text = event.title
        time.text = CalendarUtils.getStartEndTimefromDateTimestamp(startTime: event.startDate, endTime: event.endDate)
        location.text = event.location
    }

    @IBAction func closeDetailView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func joinEvent(_ sender: Any) {
        if let jointButton = sender as? UIButton {
            // TODO: Add player to document
            jointButton.isHidden = true
        }
    }

}
