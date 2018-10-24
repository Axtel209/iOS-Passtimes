//
//  Event.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

extension DocumentReference: DocumentReferenceType {}

class Event: Codable {

    let id: String
    let hostId: String
    let hostThumbnail: String
    let sport: String
    let title: String
    let latitude: Double
    let longitude: Double
    let location: String
    let startDate: Int
    let endDate: Int
    let maxPlayers: Int
    var attendingUsers: [DocumentReference]

    init(id: String, hostId: String, hostThumbnail: String, sport: String, title: String, latitude: Double, longitude: Double, location: String, startDate: Int, endDate: Int, maxPlayers: Int, attendingUsers: [DocumentReference]) {
        self.id = id
        self.hostId = hostId
        self.hostThumbnail = hostThumbnail
        self.sport = sport
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.maxPlayers = maxPlayers
        self.attendingUsers = attendingUsers
    }

}
