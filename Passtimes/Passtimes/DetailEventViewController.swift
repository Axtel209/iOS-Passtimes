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
import MapKit

class DetailEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var delete: UIButton!
    @IBOutlet var edit: UIButton!
    @IBOutlet var join: UIButton!
    @IBOutlet var hostImage: UIImageView!
    @IBOutlet var month: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var sport: UILabel!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var attendeesCount: UILabel!

    @IBOutlet var mapCard: UIView!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet var attendeesCollectionView: UICollectionView!

    /* Member Variables */
    var eventId: String?
    var event: Event?
    var player: Player?
    var host: Player?
    var attendees: [String: Player] = [:]
    var attendeesList: [Player] = []
    var mDb: DatabaseUtils!
    var listeners: [ListenerRegistration] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        attendeesCollectionView.register(UINib(nibName: "PlayerList", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendeesCollectionView.delegate = self
        attendeesCollectionView.dataSource = self

        map.roundedCorners(radius: 10)
        mapCard.backgroundColor = UIColor.clear
        mapCard.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let eventId = eventId {
            // Read event document from Firestore
            mDb = DatabaseUtils.sharedInstance
            listeners.append(mDb.readDocument(from: .events, reference: eventId, returning: Event.self) { (eventObject) in
                self.event = eventObject
                // Get player DocumentReference
                self.listeners.append(self.mDb.readDocument(from: .players, reference: self.event!.eventHost.documentID, returning: Player.self, completion: { (hostObject) in
                    self.host = hostObject
                    self.populateDetailView(with: self.event!, host: self.host!)
                }))
                
                // Get each player from the attendee list
                self.attendees.removeAll()
                for attendee in eventObject.attendees {
                    self.listeners.append(self.mDb.readDocument(from: .players, reference: attendee.documentID, returning: Player.self, completion: { (playerObject) in
                        self.attendees[playerObject.id] = playerObject
                        self.attendeesList.removeAll()
                        self.attendeesList = Array(self.attendees.values)
                        self.attendeesCollectionView.reloadData()
                    }))
                }
            })
        } else {
            SnackbarUtils.snackbarMake(message: "Could not load the event details, please check internet connection", title: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

    func populateDetailView(with event: Event, host: Player) {
        // If the person viewing the event is the host show Delete bubtton
        guard let player = AuthUtils.currentUser() else { return }
        let attendees = event.attendees
        let playerRef = mDb.documentReference(docRef: player.id, from: .players)

        if (player.id == host.id) {
            if !event.isClosed {
                join.isHidden = false
                delete.isHidden = false
                edit.isHidden = false
            } else {
                join.isHidden = true
                delete.isHidden = true
                edit.isHidden = true
            }
            join.setTitle("Close Event", for: .normal)
            join.backgroundColor = #colorLiteral(red: 0.9257785678, green: 0.1494095027, blue: 0.3405916691, alpha: 1)
            join.tag = 1
            delete.setImage(#imageLiteral(resourceName: "ic_delete"), for: .normal)
            delete.tag = 0
        } else if (isPlayerAttending(attendees: attendees, playerRef: playerRef)) {
            if event.isClosed {
                delete.isHidden = true
            } else {
                delete.isHidden = false
            }
            delete.setImage(#imageLiteral(resourceName: "ic_logout_black"), for: .normal)
            delete.tag = 1
            join.isHidden = true
        } else {
            if !event.isClosed {
                join.isHidden = false
            } else {
                join.isHidden = true
            }
            join.setTitle("Join Event", for: .normal)
            join.backgroundColor = #colorLiteral(red: 0.08800473064, green: 0.808358252, blue: 0.7374972701, alpha: 1)
            join.tag = 0
        }

        // Set imageView round and Download image and
        hostImage.roundedCorners(radius: hostImage.frame.size.height / 2)
        hostImage.kf.setImage(with: URL(string: host.thumbnail))
        month.text = CalendarUtils.getMonthFromDateTimestamp(event.startDate)
        day.text = CalendarUtils.getDayFromDateTimestamp(event.startDate)
        sport.text = event.sport
        eventTitle.text = event.title
        time.text = CalendarUtils.getStartEndTimefromDateTimestamp(startTime: event.startDate, endTime: event.endDate)
        location.text = event.location
        attendeesCount.text = "\(event.attendees.count)/\(event.maxAttendees)"

        // Set map location
        let coordinates = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        self.map.addAnnotation(annotation)
        self.map.setRegion(region, animated: false)
        self.map.isUserInteractionEnabled = false
    }

    @IBAction func closeDetailView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteEvent(_ sender: UIButton) {
        guard let event = event else { return }
        guard let player = AuthUtils.currentUser() else { return }
        let eventRef = mDb.documentReference(docRef: event.id, from: .events)
        let playerRef = mDb.documentReference(docRef: player.id, from: .players)

        if sender.tag == 0 {
            AlertUtils.AlertMake(view: self, title: "", message: "Are you sure you want to delete this event?", style: .alert) { (success) in
                if success {
                    self.mDb.updateDocument(withReference: player.id, from: .players, data: ["attending": FieldValue.arrayRemove([eventRef])], completion: nil)
                    self.mDb.updateDocument(withReference: event.id, from: .events, data: ["attendees": FieldValue.arrayRemove([playerRef])], completion: nil)
                    self.mDb.deleteDocument(withReference: event.id, from: .events) { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            AlertUtils.AlertMake(view: self, title: "", message: "Are you sure you want to leave this event?", style: .alert) { (success) in
                if success {
                    self.mDb.updateDocument(withReference: player.id, from: .players, data: ["attending": FieldValue.arrayRemove([eventRef])]) { (success) in
                        self.mDb.updateDocument(withReference: event.id, from: .events, data: ["attendees": FieldValue.arrayRemove([playerRef])], completion: nil)
                        sender.isHidden = true
                        self.join.isHidden = false
                    }
                }
            }
        }
    }

    @IBAction func directions(_ sender: Any) {
        let coordinates = CLLocationCoordinate2D(latitude: event!.latitude, longitude: event!.longitude)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        destination.name = event!.title
        MKMapItem.openMaps(with: [destination], launchOptions: options)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let edit = sender as? Bool, let destination = segue.destination as? CreateEventViewController {
            destination.isEditingEvent = edit
            destination.editingEvent = event
        }
        if let nav = segue.destination as? UINavigationController, let destination = nav.viewControllers.first as? CompleteEventViewController {
            //destination.event = event!
            destination.event = event!
        }
    }

    @IBAction func editEvent(_ sender: Any) {
        performSegue(withIdentifier: "toCreateView", sender: true)
    }

    @IBAction func joinEvent(_ sender: UIButton) {
        if sender.tag == 0 {
            if event!.attendees.count < event!.maxAttendees {
                addPlayerToAttendees()
                addEventToAttending()
            } else {
                SnackbarUtils.snackbarMake(message: "Sorry there is no space left to join", title: nil)
            }
        } else {
            // If tag == 1 it is setting the event to complete and
            AlertUtils.AlertMake(view: self, title: "", message: "Are you sure you want to close this event? This action can not be undone.", style: .alert, complition: { (success) in
                if success {
                    self.mDb.updateDocument(withReference: self.event!.id, from: .events, data: ["isClosed": true]) { (_) in
                        self.performSegue(withIdentifier: "toAttendance", sender: nil)
                    }
                }
            })

        }
    }

    // Returns true if the user was succesfully added to attendees
    private func addPlayerToAttendees() {
        guard let event = event else { return }
        guard let player = AuthUtils.currentUser() else { return }

        // List of attendees
        //var attendees = event.attendees
        // Get CurrentPlayer DocumentReference
        let playerRef = mDb.documentReference(docRef: player.id, from: .players)
        // Update attendees to Firestore
        mDb.updateDocument(withReference: event.id, from: .events, data: ["attendees": FieldValue.arrayUnion([playerRef])]) { (success) in
            if(success) {
                self.join.isHidden = true
            } else {
                SnackbarUtils.snackbarMake(message: "Could't join event", title: nil)
            }
        }
    }

    private func addEventToAttending() {
        guard let event = event else { return }
        guard let player = AuthUtils.currentUser() else { return }

        let eventRef = mDb.documentReference(docRef: event.id, from: .events)
        mDb.updateDocument(withReference: player.id, from: .players, data: ["attending": FieldValue.arrayUnion([eventRef])], completion: nil)
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

extension DetailEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendees.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 55)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PlayerListCollectionViewCell

        let player = attendeesList[indexPath.row]

        cell.configureCell(with: player)

        return cell
    }

}
