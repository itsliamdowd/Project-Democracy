//
//  BalletpediaModel.swift
//  Democracy
//
//  Created by Jevon Mao on 9/3/22.
//

import Foundation
import SwiftyJSON

extension URLSession {
    func codableTask(with request: Endpoint,
                                 completionHandler: @escaping (JSON?) -> Void) -> Void {
        return self.dataTask(with: request.request) { data, response, error in
            guard let data = data,
                  let urlResponse = response as? HTTPURLResponse,
                  error == nil
            else {
                completionHandler(nil)
                return
            }
            guard (200...299).contains(urlResponse.statusCode)
            else {
                completionHandler(nil)
                return
            }
            completionHandler(try? JSON(data: data))
        }.resume()
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
