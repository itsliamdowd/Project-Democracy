//
//  RepresentativesModel.swift
//  Democracy
//
//  Created by Liam Dowd on 10/30/22.
//

import Foundation
import SwiftyJSON

struct Current: Codable, Hashable {
    struct Representatives: Codable, Hashable {
        var people: Representative
    }
    
    struct Representative: Codable, Hashable {
        var name: String
        var party: String?
        var phone: String?
        var address: String?
        var url: URL?
        var imageUrl: URL?
        var sectors: [String: String]
        var organizations: [String: String]
        var twitterUrl: String?
        var facebookUrl: URL?
        var biography: String?
    }
}
