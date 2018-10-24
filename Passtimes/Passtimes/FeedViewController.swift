//
//  ViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /* Outlets */
    @IBOutlet var onGoingCollection: UICollectionView!

    /* Member Variables */
    var mDb: DatabaseUtils!
    var eventArray: [Event]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mDb = DatabaseUtils.sharedInstance

        onGoingCollection.register(UINib.init(nibName: "onGoingCollectionCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        onGoingCollection.delegate = self
        onGoingCollection.dataSource = self
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! OnGoingCollectionViewCell

        cell.configure()

        return cell
    }


}

