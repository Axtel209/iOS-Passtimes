//
//  Event.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Event: Codable {

    var id: String
    let eventHost: DocumentReference
    let sport: String
    var title: String
    var latitude: Double
    var longitude: Double
    var location: String
    var startDate: Int
    var endDate: Int
    var maxPlayers: Int
    var attendees: [DocumentReference]

    init(eventHost: DocumentReference, sport: String, title: String, latitude: Double, longitude: Double, location: String, startDate: Int, endDate: Int, maxPlayers: Int, attendees: [DocumentReference]) {
        self.id = UUID.init().uuidString
        self.eventHost = eventHost
        self.sport = sport
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.maxPlayers = maxPlayers
        self.attendees = attendees
    }

    var setId: String {
        set { id = newValue }
        get { return id }
    }

}
