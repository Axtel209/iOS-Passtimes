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

    let id: String
    let eventHost: DocumentReference
    let sport: String
    var sportThumbnail: String
    var title: String
    var latitude: Double
    var longitude: Double
    var location: String
    var startDate: Int
    var endDate: Int
    var maxAttendees: Int
    var attendees: [DocumentReference]
    var isClosed: Bool = false

    init(eventHost: DocumentReference, sport: String, sportThumbnail: String, title: String, latitude: Double, longitude: Double, location: String, startDate: Int, endDate: Int, maxAttendees: Int, attendees: [DocumentReference]) {
        self.id = UUID.init().uuidString
        self.eventHost = eventHost
        self.sport = sport
        self.sportThumbnail = sportThumbnail
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.maxAttendees = maxAttendees
        self.attendees = attendees
    }
}
