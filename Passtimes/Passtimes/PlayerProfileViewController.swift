//
//  PlayerProfileViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/18/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PlayerProfileViewController: UIViewController {

    @IBOutlet var attendingCollection: UICollectionView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var overallXP: UILabel!

    /* Member Variables */
    var playerId: String!
    var mDb: DatabaseUtils!
    var player: Player!
    var attendingEvents: [String: Event] = [:]
    var attendingEventsArray: [Event] = []
    var listeners: [ListenerRegistration] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        attendingCollection.register(UINib(nibName: "AttendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendingCollection.delegate = self
        attendingCollection.dataSource = self
        attendingCollection.backgroundView = background(message: "No past events")
    }

    func background(message: String) -> UILabel {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        messageLabel.sizeToFit()

        return messageLabel
    }

    override func viewWillAppear(_ animated: Bool) {
        mDb = DatabaseUtils.sharedInstance
        listeners.append(self.mDb.readDocument(from: .players, reference: playerId, returning: Player.self) { (playerObject) in
            self.player = playerObject
            self.viewSetUp()
            self.attendingEvents.removeAll()
            self.attendingEventsArray.removeAll()
            for attending in self.player.attending {
                self.listeners.append(self.mDb.readDocument(from: .events, reference: attending.documentID, returning: Event.self) { (eventObject) in
                    if eventObject.endDate < CalendarUtils.dateToMillis(Date()) || eventObject.isClosed {
                        self.attendingEvents[eventObject.id] = eventObject
                    } else {
                        self.attendingEvents.removeValue(forKey: eventObject.id)
                    }
                    self.attendingEventsArray = self.attendingEvents.values.sorted(by: { $0.startDate < $1.startDate })
                    self.attendingCollection.reloadData()
                })
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

    func viewSetUp() {
        //profilePhoto.backgroundColor = UIColor.clear
        profilePhoto.drawShadow(offset: CGSize(width: 0, height: 2), radius: profilePhoto.frame.height / 2, opacity: 0.2)
        profilePhoto.roundedCorners(radius: profilePhoto.frame.height / 2)
        profilePhoto.kf.setImage(with: URL(string: player.thumbnail))

        name.text = player.name

        overallXP.text = String(player.overallXP)
    }

    @IBAction func closePlayerDetail() {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sender as? Int, let destination = segue.destination as? DetailEventViewController {
            destination.eventId = attendingEventsArray[index].id
        }
    }

}

extension PlayerProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if attendingEventsArray.count <= 0 {
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return attendingEventsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! AttendingCollectionViewCell

        let event = attendingEventsArray[indexPath.row]

        cell.configureCell(with: event)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailView", sender: indexPath.row)
    }

}
