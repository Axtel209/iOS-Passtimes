//
//  ProfileViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/28/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {

    /* Outlets */
    @IBOutlet var attendingCollection: UICollectionView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var overallXP: UILabel!

    /* Member Variables */
    var queue: DispatchGroup!
    var mDb: DatabaseUtils!
    var player: Player!
    var attendingEvents: [String: Event] = [:]
    var attendingEventsArray: [Event] = []
    var listeners: [ListenerRegistration] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        queue = DispatchGroup()

        attendingCollection.register(UINib(nibName: "AttendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendingCollection.delegate = self
        attendingCollection.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        mDb = DatabaseUtils.sharedInstance
        listeners.append(self.mDb.readDocument(from: .players, reference: AuthUtils.currentUser()!.id, returning: Player.self) { (playerObject) in
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
        print("Listener Removed")
    }

    func viewSetUp() {
        //profilePhoto.backgroundColor = UIColor.clear
        profilePhoto.drawShadow(offset: CGSize(width: 0, height: 2), radius: profilePhoto.frame.height / 2, opacity: 0.2)
        profilePhoto.roundedCorners(radius: profilePhoto.frame.height / 2)
        profilePhoto.kf.setImage(with: URL(string: player.thumbnail))

        name.text = player.name

        overallXP.text = String(player.overallXP)
    }

    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfile", sender: nil)
    }

    @IBAction func logout(_ sender: Any) {
        AuthUtils.signOut()
        if let onboarding = UIStoryboard(name: "OnBoarding", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
            present(onboarding, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sender as? Int, let destination = segue.destination as? DetailEventViewController {
            destination.eventId = attendingEventsArray[index].id
        }
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
