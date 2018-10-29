//
//  EditProfileViewController.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/29/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    /* Outlets */
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var name: UITextField!

    /* Member Variables */
    var player : Player!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentPlayer = AuthUtils.currentUser() else { return }
        player = currentPlayer

        self.profilePhoto.roundedCorners(radius: self.profilePhoto.frame.height / 2)
        self.profilePhoto.kf.setImage(with: URL(string: player.thumbnail))
    }

    @IBAction func editImage(_ sender: Any) {
        ImagePickerUtils().pickImage(self) { (chosenImage) in
            self.profilePhoto.image = chosenImage
        }
    }

    @IBAction func updateProfile(_ sender: Any) {
        if let name = name.text, !name.isEmpty {
            guard let data = profilePhoto.image?.jpegData(compressionQuality: 1) else { return }
            StorageUtils.uploadImage(into: .profiles, withPath: player.id, image: data) { (imageURL) in
                AuthUtils.updateUserInfo(name: name, photo: imageURL)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
