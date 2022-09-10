//
//  Endpoints.swift
//  Democracy
//
//  Created by Jevon Mao on 9/3/22.
//

import Foundation
import CoreLocation

typealias api = Constants.API
struct Endpoint {
    fileprivate var scheme: String { "https" }
    fileprivate var host: String
    fileprivate var path: String
    fileprivate var queryItems = [URLQueryItem]()
    fileprivate var requestHeaders: [String: String] = ["User-Agent": "Democracy app"]
    fileprivate var requestBody: [String: String] = [:]
    fileprivate var httpMethod: RequestMethod


    enum RequestMethod: String {
        case POST, GET
    }

    enum APIRoutes{
        typealias Address = String
        case ballotpediaElectionInfo(location: CLLocationCoordinate2D)
        case voterbaseElectionInfo(location: Address)

    }
}

extension Endpoint {
    private var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        for header in requestHeaders {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }

        return request
    }

    static func getAPI(from route: APIRoutes) -> Endpoint {
        var queryItems = [URLQueryItem]()
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"

        switch route {
        case .ballotpediaElectionInfo(let location):
            queryItems.append(.init(name: api.volunteerLabel, value: String(true)))
            queryItems.append(.init(name: api.latitudeLabel, value: String(location.latitude)))
            queryItems.append(.init(name: api.longtitudeLabel, value: String(location.longitude)))
            headers["Origin"] = api.ballotpediaOriginValue
            var endpoint = Endpoint(host: api.ballotpediaHost,
                                    path: api.ballotpediaPath,
                                    httpMethod: .GET)
            endpoint.queryItems.append(contentsOf: queryItems)
            endpoint.requestHeaders.merge(headers, uniquingKeysWith: { (_, last) in last })
            return endpoint

        case .voterbaseElectionInfo(let address):
            queryItems.append(.init(name: api.addressLabel, value: address))
            var endpoint = Endpoint(host: api.voterbaseHost,
                                    path: api.voterbasePath,
                                    httpMethod: .GET)
            endpoint.queryItems.append(contentsOf: queryItems)
            endpoint.requestHeaders.merge(headers, uniquingKeysWith: { (_, last) in last })
            return endpoint

        }
    }


}
