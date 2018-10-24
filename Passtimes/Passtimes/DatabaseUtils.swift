//
//  DatabaseUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseFirestore

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

    public func reference(to collectionReference: DatabaseReferences) -> CollectionReference {
        return db.collection(collectionReference.rawValue)
    }
}
