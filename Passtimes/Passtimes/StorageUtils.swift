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

        
        let ref = storage.child(reference.rawValue).child(path).child("profile_picture")
        ref.putData(data, metadata: metadata) { (data, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            print("HELLO")
            print("PASSED")
            ref.downloadURL(completion: { (url, error) in
                print("NO ERROR YET")
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }

                print("SHOULD COMPLETE")
                completion((url?.absoluteString)!)
            })

            // Get imagePath download url from storage and return it after completion
            //completion("https://firebasestorage.googleapis.com/v0/b/passtimes-application.appspot.com/o/ROOT_STORAGE_USER_PROFILES%2F6S8tBQpfU4SrWsxOZvU38w4ZEHK2%2Fprofile_picture?alt=media&token=4bf04a64-a806-4e21-a90a-4adb2d1c1453")
        }
    }

}
