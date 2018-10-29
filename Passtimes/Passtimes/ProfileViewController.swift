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
    }

    override func viewWillAppear(_ animated: Bool) {
        player = AuthUtils.currentUser()
        viewSetUp()
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
