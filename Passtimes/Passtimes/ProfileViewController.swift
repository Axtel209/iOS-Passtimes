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
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UILabel!

    /* Member Variables */
    var db: DatabaseUtils!
    var player: Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        player = AuthUtils.currentUser()
        viewSetUp()
    }

    func viewSetUp() {
        profilePhoto.roundedCorners(radius: profilePhoto.frame.height / 2)
        //profilePhoto.drawShadow(offset: CGSize(width: 0, height: 2), radius: 4.0, opacity: 0.2)
        profilePhoto.kf.setImage(with: URL(string: player.thumbnail))

        name.text = player.name
    }

    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfile", sender: nil)
    }

}
