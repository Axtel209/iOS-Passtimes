//
//  ProfileViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/28/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    /* Outlets */
    @IBOutlet var attendingCollection: UICollectionView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UILabel!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var player: Player!
    var attendingEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        attendingCollection.register(UINib(nibName: "AttendingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        attendingCollection.delegate = self
        attendingCollection.dataSource = self

        player = AuthUtils.currentUser()
        viewSetUp()

        mDb = DatabaseUtils.sharedInstance
        mDb.readDocument(from: .players, reference: player.id, returning: Player.self) { (playerObject) in
            self.attendingEvents.removeAll()
            for attending in playerObject.attending {
                self.mDb.readDocument(from: .events, reference: attending.documentID, returning: Event.self, completion: { (eventObject) in
                    self.attendingEvents.append(eventObject)
                    self.attendingCollection.reloadData()
                })
            }
        }
    }

    func viewSetUp() {
        //profilePhoto.backgroundColor = UIColor.clear
        profilePhoto.drawShadow(offset: CGSize(width: 0, height: 2), radius: profilePhoto.frame.height / 2, opacity: 0.2)
        profilePhoto.roundedCorners(radius: profilePhoto.frame.height / 2)
        profilePhoto.kf.setImage(with: URL(string: player.thumbnail))

        name.text = player.name
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

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendingEvents.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! AttendingCollectionViewCell

        let event = attendingEvents[indexPath.row]

        cell.configureCell(with: event)

        return cell
    }

}
