//
//  Sport.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation
import UIKit

class Sport: Codable {

    let id: String
    let category: String
    let idle: String
    let active: String

    init(id: String, category: String, idle: String, active: String) {
        self.id = id
        self.category = category
        self.idle = idle
        self.active = active
    }

}
