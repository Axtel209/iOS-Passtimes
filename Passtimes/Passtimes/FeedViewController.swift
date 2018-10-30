//
//  ViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    /* Outlets */
    @IBOutlet var attendingCollection: UICollectionView!
    @IBOutlet var onGoingCollection: UICollectionView!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var player: Player!
    var eventsArray: [Event] = []
    var attendingEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // CollectionView Setup
        attendingCollection.register(UINib.init(nibName: "AttendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendingCollection.delegate = self
        attendingCollection.dataSource = self

        onGoingCollection.register(UINib.init(nibName: "onGoingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        onGoingCollection.delegate = self
        onGoingCollection.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if player == nil {
            if let currentPlayer = AuthUtils.currentUser() {
                player = currentPlayer
                mDb = DatabaseUtils.sharedInstance
                // Read Attending events
                mDb.readDocument(from: .players, reference: player.id, returning: Player.self) { (playerObject) in
                    self.attendingEvents.removeAll()
                    for attending in playerObject.attending {
                        self.mDb.readDocument(from: .events, reference: attending.documentID, returning: Event.self, completion: { (eventObject) in
                            self.attendingEvents.append(eventObject)
                            self.attendingEvents = self.attendingEvents.sorted(by: { $0.startDate < $1.startDate })
                            self.attendingCollection.reloadData()
                        })
                    }
                }

                //player.favorites
                mDb.readFilteredDocument(from: .events, field: "sport", favorites: ["Basketball", "Tennis", "Soccer", "Football"]) { (objectArray) in
                    self.eventsArray = objectArray
                    // sort Array by date
                    self.eventsArray =  self.eventsArray.sorted(by: { $0.startDate < $1.startDate })
                    self.onGoingCollection.reloadData()
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        // TODO: Unregister listeners
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tuple = sender as? (IndexPath, UICollectionView), let destination = segue.destination as? DetailEventViewController {
            // Pass eventId to DetailView
            if tuple.1 == self.onGoingCollection {
                destination.eventId = eventsArray[tuple.0.row].id
            } else {
                destination.eventId = attendingEvents[tuple.0.row].id
            }
        }
    }

    @IBAction func createEvent(_ sender: Any) {
        performSegue(withIdentifier: "toCreateView", sender: nil)
    }

}

/* CollectionView */
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.onGoingCollection {
            return eventsArray.count
        }
        if collectionView == self.attendingCollection {
            return attendingEvents.count
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

            let event = eventsArray[indexPath.row]

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

            let event = attendingEvents[indexPath.row]

            cell.configureCell(with: event)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailView", sender: (indexPath, collectionView))
    }

}

