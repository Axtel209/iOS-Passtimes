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

    public func documentReference(docRef: String, from collectionReference: DatabaseReferences) -> DocumentReference {
        return reference(to: collectionReference).document(docRef)
    }

    // Add Document to Firestore
    public func addDocument<T: Codable>(withId id: String, object: T, to collectionReference: DatabaseReferences, complition: ((Bool) -> ())?) {
        do {
            // Encode object to document
            let document = try FirestoreEncoder().encode(object)

            // Add document to Firestore
            reference(to: collectionReference).document(id).setData(document) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                    complition?(false)
                    return
                }
                complition?(true)
            }
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
                    if document.exists {
                        // Decode document to object
                        let object = try FirestoreDecoder().decode(objectType, from: document.data())

                        // Add object to array
                        objectsArray.append(object)
                    }
                }
                // Return objectsArray after complition
                completion(objectsArray)
            } catch {
                print("Decoding ERROR - " + error.localizedDescription)
            }
        }
    }

    public func readFilteredDocument(from collectionReference: DatabaseReferences, field: String, values: [String], completion: @escaping ([Event]) -> Void) {
        var objectsArray: [String: Event] = [:]
        for value in values {
            reference(to: collectionReference).whereField(field, isEqualTo: value).addSnapshotListener { (querySnapshot, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }

                guard let snapshot = querySnapshot else { return }

                do {
                    try snapshot.documentChanges.forEach { diff in
                        let object = try FirestoreDecoder().decode(Event.self, from: diff.document.data())

                        if (diff.type == .added) {
                            //objectsArray.append(object)
                            objectsArray[object.id] = object
                        }
                        if (diff.type == .modified) {
                            objectsArray[object.id] = object
                        }
                        if (diff.type == .removed) {
                            objectsArray.removeValue(forKey: object.id)
                        }
                    }
                    completion(Array(objectsArray.values))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    // Retrive Document from Firestore
    public func readDocument<T: Codable>(from collectionReference: DatabaseReferences, reference documentReference: String, returning objectType: T.Type, completion: @escaping (T) -> Void) -> ListenerRegistration {
        return reference(to: collectionReference).document(documentReference).addSnapshotListener { (documentSnapshot, error) in
            // if there is an error return
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            // Validate DocumentSnapshot and data
            guard let document = documentSnapshot else { return }
            guard let data = document.data() else { return }

            do {
                if document.exists {
                    // Decode document to object
                    let object = try FirestoreDecoder().decode(objectType, from: data)

                    // Return object after complition
                    completion(object)
                } else {
                    let documentRef = self.reference(to: collectionReference).document(document.documentID)
                    if objectType == Player.self {
                        self.updateDocument(withReference: document.documentID, from: collectionReference, data: ["attending": FieldValue.arrayRemove([documentRef])], completion: nil)
                    } else {
                        self.updateDocument(withReference: document.documentID, from: collectionReference, data: ["attendees": FieldValue.arrayRemove([documentRef])], completion: nil)
                    }
                }
            } catch {
                print("Decoding Document Error - " + error.localizedDescription)
            }
        }
    }

    public func deleteDocument(withReference documentReference: String, from collectionReference: DatabaseReferences, completion: @escaping (Bool) -> Void) {
        reference(to: collectionReference).document(documentReference).delete { (error) in
            if error != nil {
                print("Problem deleting Document ERROR - " + error!.localizedDescription)
                completion(false)
                return
            }

            completion(true)
        }
    }

    public func updateDocument(withReference documentReference: String, from collectionReference: DatabaseReferences, data: [String: Any], completion: ((Bool) -> ())?) {
        // Update Document
        reference(to: collectionReference).document(documentReference).updateData(data) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }

            completion?(true)
        }
    }

}
