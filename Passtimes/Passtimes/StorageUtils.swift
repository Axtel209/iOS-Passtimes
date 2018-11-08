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

        
        let ref = storage.child(reference.rawValue).child(path).child("profile_picture_\(path)")
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
        }
    }

}
