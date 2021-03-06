//
//  AuthUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthUtils {

//    private let auth: Auth!
//
//    // Get class Instance
//    class var sharedInstance: AuthUtils {
//        struct Static {
//            static let instance = AuthUtils()
//        }
//        return Static.instance
//    }
//
//    private init() {
//        auth = Auth.auth();
//    }

    private static let auth = Auth.auth()

    public static func currentUser() -> Player? {
        if let user = auth.currentUser, let name = user.displayName, let thumbnail = user.photoURL {
            return Player(id: user.uid, name: name, thumbnail: thumbnail.absoluteString)
        }

        return nil
    }

    public static func isUserCurrentlySignedIn() -> Bool {
        // Check if current User is signed in
        if auth.currentUser != nil { return true }

        return false
    }

    public static func signOut() {
        do {
            try auth.signOut()
        } catch {
            print("Sign Out - ERROR")
        }
    }

    public static func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (Bool) -> Void) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                print(error!.localizedDescription)
                //SnackbarUtils.snackbarMake(message: error!.localizedDescription, title: nil)
                completion(false)
                return
            }

            // Completion
            completion(true)
        }
    }

    public static func signUpwithEmailAndPassword(email: String, password: String, name: String, photo: Data, completion: ((Bool) -> Void)?) {
        auth.createUser(withEmail: email, password: password) { (authData, error) in
            if error != nil {
                SnackbarUtils.snackbarMake(message: error!.localizedDescription, title: nil)
                completion?(false)
                return
            }

            guard let data = authData else { return }

            //StorageUtils.uploadImage(into: .profiles, withPath: data.user.uid, image: photo,
            StorageUtils.uploadImage(into: .profiles, withPath: data.user.uid, image: photo, completion: { (thumbnail) in
                let player = Player(id: data.user.uid, name: name, thumbnail: thumbnail)

                let db = DatabaseUtils.sharedInstance
                db.addDocument(withId: player.id, object: player, to: .players, complition: { (success) in
                    updateUserInfo(name: player.name, photo: player.thumbnail)
                    completion?(success)
                })
            })
        }
    }

    private static func insertUserIntoDatabase(uid: String, name: String, thumbnail: String) {
        let player = Player(id: uid, name: name, thumbnail: thumbnail)
        let db = DatabaseUtils.sharedInstance
        db.addDocument(withId: uid, object: player, to: .players, complition: nil)
        updateUserInfo(name: name, photo: thumbnail)
    }

    static func updateUserInfo(name: String, photo: String) {
        guard let changeRequest = auth.currentUser?.createProfileChangeRequest() else { return }
        changeRequest.displayName = name
        changeRequest.photoURL = URL(string: photo)

        changeRequest.commitChanges(completion: { (error) in
            if error != nil {
                print("User change request - ERROR")
                return
            }
        })
    }

}
