//
//  Player.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/25/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Player: Codable {

    let id: String
    var name: String
    var thumbnail: String
    var overallXP: Int = 0
    var favorites: [DocumentReference] = []
    var attending: [DocumentReference] = []

    init(id: String, name: String, thumbnail: String) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }

    convenience init(id: String, name: String, thumbnail: String, overallXP: Int, favorites: [DocumentReference], attending: [DocumentReference]) {
        self.init(id: id, name: name, thumbnail: thumbnail)
        self.overallXP = overallXP
        self.favorites = favorites
        self.attending = attending
    }

}
