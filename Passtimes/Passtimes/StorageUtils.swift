//
//  StorageUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/27/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

// Each Firestore Collection Reference
enum StorageReference: String {
    case profiles = "ROOT_STORAGE_USER_PROFILES"
}

class StorageUtils {

    private static let storage = Storage.storage().reference()

    public static func uploadImage(into reference: StorageReference, withPath path: String, image data: Data, completion: @escaping (String) -> Void) {
        // Store the picture
        storage.child(reference.rawValue).child(path).child("profilePicture.png").putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            // Get imagePath from storage and return it after completion
            guard let downloadURL = metadata?.path else { return }
            //downloadURL
            completion(downloadURL)
        }
    }

}
