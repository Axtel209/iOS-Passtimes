//
//  LeaderboardViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 11/7/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LeaderboardViewController: UIViewController {

    @IBOutlet var playerCard: UIView!
    @IBOutlet var playerPhoto: UIImageView!
    @IBOutlet var playerName: UILabel!
    @IBOutlet var playerScore: UILabel!
    @IBOutlet var playerRank: UILabel!

    @IBOutlet var rankingList: UICollectionView!

    var mDb: DatabaseUtils!
    var listeners: [ListenerRegistration] = []
    var player: Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        rankingList.register(UINib(nibName: "PlayerList", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        rankingList.delegate = self
        rankingList.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        mDb = DatabaseUtils.sharedInstance
        listeners.append(self.mDb.readDocument(from: .players, reference: AuthUtils.currentUser()!.id, returning: Player.self) { (playerObject) in
            self.player = playerObject
            self.viewSetUp()
        })
    }
    
    func viewSetUp() {
        self.playerCard.layer.cornerRadius = 10
        self.playerCard.layer.masksToBounds = true
        //self.playerCard.backgroundColor = UIColor.clear
        self.playerCard.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)

        self.playerPhoto.roundedCorners(radius: playerPhoto.frame.height / 2)
        self.playerPhoto.kf.setImage(with: URL(string: player.thumbnail))
        self.playerName.text = player.name
        self.playerScore.text = String(player.overallXP)
    }

    override func viewWillDisappear(_ animated: Bool) {
        for listener in listeners {
            listener.remove()
        }
    }

}

extension LeaderboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! PlayerListCollectionViewCell



        return cell
    }

}
