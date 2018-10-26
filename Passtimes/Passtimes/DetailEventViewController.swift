//
//  DetailEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class DetailEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var delete: UIButton!
    @IBOutlet var join: UIButton!
    @IBOutlet var hostImage: UIImageView!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!

    /* Member Variables */
    var auth: AuthUtils!
    var eventId: String?
    var event: Event?
    var mDb: DatabaseUtils!

    override func viewDidLoad() {
        super.viewDidLoad()

        auth = AuthUtils.sharedInstance

        // Validate for eventId
        if let eventId = eventId {
            // Read event document from Firestore
            mDb = DatabaseUtils.sharedInstance
            mDb.readDocument(from: .events, reference: eventId, returning: Event.self) { (object) in
                self.event = object
                self.populateDetailView(with: object)
            }
        } else {
            // TODO: Chould not load event
        }
    }

    func populateDetailView(with event: Event) {
        // If the person viewing the event is the host show Delete bubtton
        if let player = auth.currentUser(), event.hostId == player.id {
            join.isHidden = true
            //TODO: CHANGE - should display if the user is not in the attending list
            delete.isHidden = false
        }

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

    @IBAction func deleteEvent(_ sender: Any) {
        if let event = event {
            //SnackbarUtils.createSnackbar(message: "Are you sure you want to delete the event?", action: MDCSnackbarMessageAction(), title: "Delete")
//            SnackbarUtils.snackbarMake(message: "Are you sure you want to delete the event?", snackbarAction: nil, title: nil)
            mDb.delete(document: event.id, from: .events) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func joinEvent(_ sender: Any) {
        if let jointButton = sender as? UIButton {
            // TODO: Add player to document
            jointButton.isHidden = true
        }
    }

}
