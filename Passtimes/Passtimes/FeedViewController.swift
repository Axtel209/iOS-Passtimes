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
    @IBOutlet var onGoingCollection: UICollectionView!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var eventsArray: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mDb = DatabaseUtils.sharedInstance
        mDb.readDecuments(from: .events, returning: Event.self) { (objectsArray) in
            self.eventsArray = objectsArray
            self.onGoingCollection.reloadData()
        }

        // CollectionView Setup
        onGoingCollection.register(UINib.init(nibName: "onGoingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        onGoingCollection.delegate = self
        onGoingCollection.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath, let destination = segue.destination as? DetailEventViewController {
            // Pass eventId to DetailView
            destination.eventId = eventsArray[indexPath.row].id
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
        return eventsArray.count
    }

    // Set CollectionViewCell dimentions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 341, height: 122)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! OnGoingCollectionViewCell

        let event = eventsArray[indexPath.row]

        // Configure cell properties
        cell.configureCell(with: event)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailView", sender: indexPath)
    }

}

