//
//  EncodableExtension.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/24/18.
//  Copyright © 2018 Passtimes. All rights reserved.
//

import Foundation

enum EncodingError: Error {
    case classObjectError
}

extension Encodable {

    func toJson() throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])

        guard let json = jsonObject as? [String: Any] else { throw EncodingError.classObjectError }

        return json
    }

}
