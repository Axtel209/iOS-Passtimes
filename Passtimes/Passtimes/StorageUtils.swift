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
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storage.child(reference.rawValue).child(path).child("profile_picture").putData(data, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            //metadata?.storageReference?.downloadURL(completion: <#T##(URL?, Error?) -> Void#>)


            // Get imagePath download url from storage and return it after completion
            completion("https://firebasestorage.googleapis.com/v0/b/passtimes-application.appspot.com/o/ROOT_STORAGE_USER_PROFILES%2FgZXnEEMIYKOhDiCVxxowsk8rXNE2%2Fprofile_picture?alt=media&token=0b50f4c3-7e4b-42ba-8465-ee20e2ff784a")
        }
    }

}
