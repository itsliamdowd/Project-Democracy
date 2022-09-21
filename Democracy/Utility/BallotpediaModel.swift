//
//  BalletpediaModel.swift
//  Democracy
//
//  Created by Jevon Mao on 9/3/22.
//

import Foundation
import SwiftyJSON

struct BallotpediaElection: Codable {
    let date: Date
    let districts: [District]

    struct District: Codable {
        let name: String
        let type: String
        let races: [Race]
    }

    struct Race: Codable {
        let name: String
        let level: ElectionLevel
        let candidates: [Candidate]

    }

    struct Candidate: Codable {
        let name: String
        let party: String?
        let imageUrl: URL?
        let isIncumbent: String
        let socialMedia: String
        let website: String
        let occupation: String
    }

    enum ElectionLevel: String, Codable {
        case federal, state, local
    }
}


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
