//
//  DatabaseUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

// Makes Firestore "DocumentReference" datatype Codable
extension DocumentReference: DocumentReferenceType {}

// Each Firestore Collection Reference
enum DatabaseReferences: String {
    case events
    case players
    case sports
}

class DatabaseUtils {

    private let db: Firestore!

    // Get class Instance
    class var sharedInstance: DatabaseUtils {
        struct Static {
            static let instance = DatabaseUtils()
        }
        return Static.instance
    }
    
    private init() {
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }

    // Get CollectionReference from Firestore
    private func reference(to collectionReference: DatabaseReferences) -> CollectionReference {
        return db.collection(collectionReference.rawValue)
    }

    // Add Document to Firestore
    public func addDocument<T: Codable>(object: T, to collectionReference: DatabaseReferences) {
        do {
            // Encode object to document
            let document = try FirestoreEncoder().encode(object)

            // Add document to Firestore
            reference(to: collectionReference).addDocument(data: document)
        } catch {
            print("Encoding ERROR - " + error.localizedDescription)
        }
    }

    // Retrieve Documents from Firestore
    public func readDecuments<T: Codable>(from collectionReference: DatabaseReferences, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        reference(to: collectionReference).addSnapshotListener { (snapshot, error) in
            // if there is an error return
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            // Validate snapshot
            guard let snapshot = snapshot else { return }

            do {
                var objectsArray: [T] = []

                for document in snapshot.documents {
                    // Decode document to object
                    let object = try FirestoreDecoder().decode(objectType, from: document.data())

                    // Add object to array
                    objectsArray.append(object)
                }

                // Return objectsArray after complition
                completion(objectsArray)
            } catch {
                print("Decoding ERROR - " + error.localizedDescription)
            }

        }
    }

    // Retrive Document from Firestore
    public func readDocument<T: Codable>(from collectionReference: DatabaseReferences, reference documentReference: String, returning objectType: T.Type, completion: @escaping (T) -> Void) {
        reference(to: collectionReference).document(documentReference).addSnapshotListener { (documentSnapshot, error) in
            // if there is an error return
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            // Validate DocumentSnapshot and data
            guard let documentSnapshot = documentSnapshot else { return }
            guard let data = documentSnapshot.data() else { return }

            do {
                // Decode document to object
                let object = try FirestoreDecoder().decode(objectType, from: data)

                // Return object after complition
                completion(object)
            } catch {
                print("Decoding Document Error - " + error.localizedDescription)
            }
        }
    }

    public func delete(document: String, from collectionReference: DatabaseReferences, completion: @escaping () -> Void) {
        reference(to: collectionReference).document(document).delete { (error) in
            if error != nil {
                print("Problem deleting Document ERROR - " + error!.localizedDescription)
                return
            }

            completion()
        }
    }

}
