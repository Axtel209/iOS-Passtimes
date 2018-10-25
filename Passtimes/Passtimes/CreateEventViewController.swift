//
//  CreateEventViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    /* Outlets */
    @IBOutlet var sportCollection: UICollectionView!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var sportsArray: [Sport] = []
    var isSelected: Bool = false
    var selectedIndexPath: IndexPath = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mDb = DatabaseUtils.sharedInstance
        mDb.readDecuments(from: .sports, returning: Sport.self) { (objectArray) in
            self.sportsArray = objectArray
            self.sportCollection.reloadData()
        }

        // CollectionView Setup
        sportCollection.register(UINib.init(nibName: "PickSport", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        sportCollection.delegate = self
        sportCollection.dataSource = self
    }
    

    @IBAction func closeCreateView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension CreateEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsArray.count
    }

    // Set CollectionViewCell dimentions
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
        // Toggle selected sport
        if(isSelected) {
            isSelected = true
        }

        // If there is a sport selected change back to idle
        if(!selectedIndexPath.isEmpty) {
            if let selectedSport = collectionView.cellForItem(at: selectedIndexPath) as? PickSportCollectionViewCell {
                selectedSport.configureCell(with: sportsArray[selectedIndexPath.row], isActive: false)
            }
        }

        let cell = collectionView.cellForItem(at: indexPath) as! PickSportCollectionViewCell
        cell.configureCell(with: sportsArray[indexPath.row], isActive: true)

        // Set the currently selected to be the already selected
        selectedIndexPath = indexPath
    }

}
