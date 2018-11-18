//
//  SearchViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/18/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet var playerCollection: UICollectionView!

    var searchBar: UISearchController!
    var mDb: DatabaseUtils!
    var allPlayers: [Player] = []
    var searchPlayers: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        playerCollection.register(UINib(nibName: "PlayerList", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        playerCollection.delegate = self
        playerCollection.dataSource = self
        playerCollection.backgroundView = background(message: "Passtimes")

        searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true

        mDb = DatabaseUtils.sharedInstance

        mDb.readDecuments(from: .players, returning: Player.self) { (playersArray) in
            self.allPlayers.removeAll()
            self.allPlayers = playersArray
        }
    }

    func background(message: String) -> UILabel {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "KittenSwash", size: 34) //UIFont.boldSystemFont(ofSize: 15)
        messageLabel.sizeToFit()

        return messageLabel
    }

    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            searchPlayers = allPlayers
        } else {
            searchPlayers = allPlayers.filter{ $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        self.playerCollection.reloadData()
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchPlayers.count <= 0 {
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return searchPlayers.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 55)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PlayerListCollectionViewCell

        let player = searchPlayers[indexPath.row]

        cell.configureCell(with: player)

        return cell
    }

}
