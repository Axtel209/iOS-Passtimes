//
//  DetailEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore
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
    var eventId: String?
    var event: Event?
    var host: Player?
    var mDb: DatabaseUtils!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Validate for eventId
        if let eventId = eventId {
            // Read event document from Firestore
            mDb = DatabaseUtils.sharedInstance
            mDb.readDocument(from: .events, reference: eventId, returning: Event.self) { (eventObject) in
                self.event = eventObject
                // Get player DocumentReference
                self.mDb.readDocument(from: .players, reference: eventObject.eventHost.documentID, returning: Player.self, completion: { (hostObject) in
                    self.host = hostObject
                    self.populateDetailView(with: self.event!, host: self.host!)
                })
            }
        } else {
            // TODO: Chould not load event
        }

        //self.populateDetailView(with: object)
    }

    func populateDetailView(with event: Event, host: Player) {
        // If the person viewing the event is the host show Delete bubtton
        guard let player = AuthUtils.currentUser() else { return }
        let attendees = event.attendees
        let playerRef = mDb.documentReference(docRef: player.id, from: .players)

        if (player.id == host.id) {
            join.isHidden = true
            delete.isHidden = false
        } else if (isPlayerAttending(attendees: attendees, playerRef: playerRef)) {
            join.isHidden = true
        }

        // Set imageView round and Download image and
        hostImage.roundedCorners(radius: hostImage.frame.size.height / 2)
        hostImage.kf.setImage(with: URL(string: host.thumbnail))
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
        guard let event = event else { return }

        //SnackbarUtils.snackbarMake(message: "Are you sure you want to delete the event?", snackbarAction: nil, title: nil)
        mDb.deleteDocument(withReference: event.id, from: .events) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func joinEvent(_ sender: Any) {
        addPlayerToAttendees()
    }

    // Returns true if the user was succesfully added to attendees
    func addPlayerToAttendees() {
        guard let event = event else { return }
        guard let player = AuthUtils.currentUser() else { return }

        // List of attendees
        //var attendees = event.attendees
        // Get CurrentPlayer DocumentReference
        let playerRef = mDb.documentReference(docRef: player.id, from: .players)
        // Update attendees to Firestore
        mDb.updateDocument(withReference: event.id, from: .events, playerRef: playerRef) { (success) in
            if(success) {
                self.join.isHidden = true
            } else {
                SnackbarUtils.snackbarMake(message: "Could't join event", title: nil)
            }
        }
    }

    // Check if player is attending
    func isPlayerAttending(attendees: [DocumentReference], playerRef: DocumentReference) -> Bool {
        for document in attendees {
            if(document.documentID == playerRef.documentID) {
                return true
            }
        }

        return false
    }
}
