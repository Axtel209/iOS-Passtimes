//
//  CompleteEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/9/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CompleteEventViewController: UIViewController {

    @IBOutlet var attendeesCollectionView: UICollectionView!

    var mDb: DatabaseUtils!
    var event: Event!
    var attendees: [String: Player] = [:]
    var attendeesList : [Player] = []
    var selectedAttendees: [String: Player] = [:]
    var listeners: [ListenerRegistration] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        attendeesCollectionView.register(UINib(nibName: "PlayerList", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendeesCollectionView.delegate = self
        attendeesCollectionView.dataSource = self

        mDb = DatabaseUtils.sharedInstance
        if let event = event {
            for player in event.attendees {
                self.listeners.append(self.mDb.readDocument(from: .players, reference: player.documentID, returning: Player.self, completion: { (playerObject) in
                    self.attendees[playerObject.id] = playerObject
                    self.attendeesList.removeAll()
                    self.attendeesList = Array(self.attendees.values)
                    self.attendeesCollectionView.reloadData()
                }))
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

    @IBAction func save(_ sender: Any) {
        let selected = Array(selectedAttendees.values)

        if selected.isEmpty {
            AlertUtils.AlertMake(view: self, title: "", message: "You have not selected anyone, are you sure? Once closed it can't be undone", style: .alert) { (success) in
                if success {
                    self.performSegue(withIdentifier: "unwindToNavigation", sender: nil)
                }
            }
        } else {
            for player in selected {
                mDb.updateDocument(withReference: player.id, from: .players, data: ["overallXP": player.overallXP + 50]) { (success) in
                    if success {
                        self.performSegue(withIdentifier: "unwindToNavigation", sender: nil)
                    } else {
                        SnackbarUtils.snackbarMake(message: "Couldn't add XP to players, please try again", title: nil)
                    }
                }
            }
        }
    }

}

extension CompleteEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendeesList.count
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PlayerListCollectionViewCell

        let selectedPlayer = attendeesList[indexPath.row]

        if selectedAttendees[selectedPlayer.id] != nil {
            selectedAttendees.removeValue(forKey: selectedPlayer.id)
        } else {
            self.selectedAttendees[selectedPlayer.id] = selectedPlayer
        }

        cell.cellSelected()
    }

}
