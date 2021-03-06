//
//  ViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore
import DropDown

class FeedViewController: UIViewController {

    /* Outlets */
    @IBOutlet var attendingCollection: UICollectionView!
    @IBOutlet var onGoingCollection: UICollectionView!

    /* Member Variables */
    let dropDown = DropDown()
    var mDb: DatabaseUtils!
    var player: Player!
    var eventsArray: [Event] = []
    var filteredEvents: [Event] = []
    var attendingEvents: [String: Event] = [:]
    var attendingEventsArray: [Event] = []
    var listeners: [ListenerRegistration] = []
    var favoriteSports: [Sport] = []
    var dropDownMenuFilter: [String] = []

    var serialQueue = DispatchQueue(label: "SerialQueue")

    override func viewDidLoad() {
        super.viewDidLoad()
        // CollectionView Setup
        attendingCollection.register(UINib.init(nibName: "AttendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendingCollection.delegate = self
        attendingCollection.dataSource = self
        attendingCollection.backgroundView = background(message: "No events attending")

        onGoingCollection.register(UINib.init(nibName: "onGoingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        onGoingCollection.delegate = self
        onGoingCollection.dataSource = self
        onGoingCollection.backgroundView = background(message: "No available events")

        // Filter events logic
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.dropDown.selectedItem == "All" {
                self.filteredEvents = self.eventsArray
            } else {
                self.filteredEvents = self.eventsArray.filter( {$0.sport == self.dropDown.selectedItem})
            }
            self.filteredEvents =  self.filteredEvents.sorted(by: { $0.startDate < $1.startDate })
            self.onGoingCollection.reloadData()
        }
    }

    func background(message: String) -> UILabel {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        messageLabel.sizeToFit()

        return messageLabel
    }

    override func viewWillAppear(_ animated: Bool) {
        if let currentPlayer = AuthUtils.currentUser() {
            player = currentPlayer
            mDb = DatabaseUtils.sharedInstance
            // Read Attending events
            self.listeners.append(self.mDb.readDocument(from: .players, reference: AuthUtils.currentUser()!.id, returning: Player.self) { (playerObject) in
                self.player = playerObject
                self.favoriteSports.removeAll()
                self.dropDownMenuFilter.removeAll()
                self.dropDownMenuFilter.append("All")
                self.attendingEvents.removeAll()
                self.attendingEventsArray.removeAll()
                for attending in self.player.attending {
                    self.listeners.append(self.mDb.readDocument(from: .events, reference: attending.documentID, returning: Event.self) { (eventObject) in
                        if eventObject.endDate > CalendarUtils.dateToMillis(Date()) && !eventObject.isClosed {
                            self.attendingEvents[eventObject.id] = eventObject
                        } else {
                            self.attendingEvents.removeValue(forKey: eventObject.id)
                        }
                        self.attendingEventsArray = self.attendingEvents.values.sorted(by: { $0.startDate < $1.startDate })
                        self.attendingCollection.reloadData()
                    })
                    self.attendingCollection.reloadData()
                }
                for (index, sport) in self.player!.favorites.enumerated() {
                    self.listeners.append(self.mDb.readDocument(from: .sports, reference: sport.documentID, returning: Sport.self, completion: { (sportObject) in
                        self.favoriteSports.append(sportObject)
                        self.dropDownMenuFilter.append(sportObject.category)
                        self.onGoingCollection.reloadData()
                        if index == self.player.favorites.count - 1 {
                            self.dropDown.dataSource = self.dropDownMenuFilter
                            self.mDb.readFilteredDocument(from: .events, field: "sport", values: self.favoriteSports) { (objectArray) in
                                self.eventsArray = objectArray.sorted(by: { $0.startDate < $1.startDate})
                                self.filteredEvents = self.eventsArray
                                self.onGoingCollection.reloadData()
                            }
                        }
                    }))
                }
                self.attendingCollection.reloadData()
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tuple = sender as? (IndexPath, UICollectionView), let destination = segue.destination as? DetailEventViewController {
            // Pass eventId to DetailView
            if tuple.1 == self.onGoingCollection {
                destination.eventId = eventsArray[tuple.0.row].id
            } else {
                destination.eventId = attendingEventsArray[tuple.0.row].id
            }
        }
    }

    @IBAction func createEvent(_ sender: Any) {
        performSegue(withIdentifier: "toCreateView", sender: nil)
    }

    @IBAction func filterEvents(_ sender: UIButton) {
        dropDown.anchorView = sender
        dropDown.width = self.view.frame.width / 3
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)! + 5)

        dropDown.show()
    }

}

/* CollectionView */
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.onGoingCollection {
            if filteredEvents.count <= 0 {
                self.onGoingCollection.backgroundView?.isHidden = false
            } else {
                self.onGoingCollection.backgroundView?.isHidden = true
            }
            return filteredEvents.count
        }
        if collectionView == self.attendingCollection {
            if attendingEventsArray.count <= 0 {
                self.attendingCollection.backgroundView?.isHidden = false
            } else {
                self.attendingCollection.backgroundView?.isHidden = true
            }
            return attendingEventsArray.count
        }

        return 0
    }

    // Set CollectionViewCell dimentions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.onGoingCollection {
            return CGSize(width: 341, height: 122)
        }
        if collectionView == self.attendingCollection {
            return CGSize(width: 165, height: 90)
        }

        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.onGoingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! OnGoingCollectionViewCell

            let event = filteredEvents[indexPath.row]

            let playerRef = mDb.documentReference(docRef: player.id, from: .players)
            if event.attendees.contains(playerRef) {
                cell.isAttending(true)
            } else {
                cell.isAttending(false)
            }

            // Configure cell properties
            cell.configureCell(with: event)

            return cell
        }
        if collectionView == self.attendingCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! AttendingCollectionViewCell

            let event = attendingEventsArray[indexPath.row]

            cell.configureCell(with: event)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailView", sender: (indexPath, collectionView))
    }

}

