//
//  PickFavoriteViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/29/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PickFavoriteViewController: UIViewController {

    /* Outlets */
    @IBOutlet var favoriteCollection: UICollectionView!
    @IBOutlet var submit: UIButton!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var sportsArray: [Sport]!
    var selectedSports: [IndexPath] = []
    var sportRefs: [DocumentReference] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteCollection.register(UINib.init(nibName: "PickSport", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        favoriteCollection.delegate = self
        favoriteCollection.dataSource = self

        mDb = DatabaseUtils.sharedInstance
        mDb.readDecuments(from: .sports, returning: Sport.self) { (objectArray) in
            self.sportsArray = objectArray
            self.favoriteCollection.reloadData()
        }
    }

    @IBAction func pickFavoriteSportSubmit(_ sender: Any) {
        // If ther is a sport selected continue
        if !selectedSports.isEmpty {
            let activityIndicator = ActivityIndicatorUtils.activityIndicatorMake(view: self.view)
            activityIndicator.startAnimating()
            self.submit.isEnabled = false

            guard let player = AuthUtils.currentUser()
                else {
                    SnackbarUtils.snackbarMake(message: "There was an authentification ERROR", title: nil)
                    return
            }

            for indexPath in selectedSports {
                let sportRef = self.mDb.documentReference(docRef: sportsArray[indexPath.row].id, from: .sports)
                sportRefs.append(sportRef)
            }

            self.mDb.updateDocument(withReference: player.id, from: .players, data: ["favorites": FieldValue.arrayUnion(sportRefs)], completion: { (success) in
                activityIndicator.stopAnimating()

                if success {
                    self.performSegue(withIdentifier: "unwindToNavigation", sender: nil)
                } else {
                    // Error trying to add Eventref to player attending
                    SnackbarUtils.snackbarMake(message: "Something went wront", title: nil)
                }

                self.submit.isEnabled = true
            })
        } else {
            SnackbarUtils.snackbarMake(message: "Please select a sport", title: nil)
        }
    }

}

extension PickFavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PickSportCollectionViewCell

        let sport = sportsArray[indexPath.row]

        cell.configureCell(with: sport, isActive: false)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PickSportCollectionViewCell

        if selectedSports.contains(indexPath) {
            selectedSports.remove(at: indexPath.row)
            cell.configureCell(with: sportsArray[indexPath.row], isActive: false)
        } else {
            selectedSports.append(indexPath)
            cell.configureCell(with: sportsArray[indexPath.row], isActive: true)
        }
    }

}
