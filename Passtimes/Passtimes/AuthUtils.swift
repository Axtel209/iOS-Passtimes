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

    private let auth: Auth!

    // Get class Instance
    class var sharedInstance: AuthUtils {
        struct Static {
            static let instance = AuthUtils()
        }
        return Static.instance
    }

    private init() {
        auth = Auth.auth();
    }

    public func currentUser() -> Player? {
        if let user = auth.currentUser, let name = user.displayName, let thumbnail = user.photoURL {
            return Player(id: user.uid, name: name, thumbnail: thumbnail.absoluteString)
        }

        return nil
    }

    public func isUserCurrentlySignedIn() -> Bool {
        // Check if current User is signed in
        if auth.currentUser != nil { return true }

        return false
    }

    public func signInWithEmailAndPassword(email: String, password: String, completion: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { (_, error) in
            if error != nil {
                // TODO: display error
            }

            // Completion
            completion()
        }
    }

}
