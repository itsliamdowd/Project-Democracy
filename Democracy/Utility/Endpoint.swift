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

    enum APIRoutes {
        typealias Address = String
        case ballotpediaElectionInfo(location: CLLocationCoordinate2D)
        case voterbaseElectionInfo(location: Address)
        case openSecrets(route: OpenSecretRoutes)

        enum OpenSecretRoutes {
            case getLegislator(state: String)
            case cardSummary(cid: String, cycle: String = "2022")
            case candContrib(cid: String, cycle: String = "2022")
        }
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

    static func getAPI(from apiEndpoint: APIRoutes) -> Endpoint {
        var queryItems = [URLQueryItem]()
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"

        switch apiEndpoint {
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

        case .openSecrets(let route):
            switch route {
            case .getLegislator(let state):
                queryItems.append(.init(name: "method", value: "getLegislators"))
                queryItems.append(.init(name: "id", value: state))
                queryItems.append(.init(name: "apikey", value: "c5d1d02a93919b2845a095e52c2af67a"))
                queryItems.append(.init(name: "output", value: "json"))
                var endpoint = Endpoint(host: api.openSecretHost,
                                        path: api.openSecretPath,
                                        httpMethod: .GET)
                endpoint.queryItems.append(contentsOf: queryItems)
                return endpoint
            case .cardSummary(let cid, let cycle):
                queryItems.append(.init(name: "method", value: "candSummary"))
                queryItems.append(.init(name: "cid", value: cid))
                queryItems.append(.init(name: "apikey", value: "c5d1d02a93919b2845a095e52c2af67a"))
                queryItems.append(.init(name: "cycle", value: cycle))
                var endpoint = Endpoint(host: api.openSecretHost,
                                        path: api.openSecretPath,
                                        httpMethod: .GET)
                endpoint.queryItems.append(contentsOf: queryItems)

                return endpoint
            case .candContrib(let cid, let cycle):
                queryItems.append(.init(name: "method", value: "candContrib"))
                queryItems.append(.init(name: "cid", value: cid))
                queryItems.append(.init(name: "apikey", value: "c5d1d02a93919b2845a095e52c2af67a"))
                queryItems.append(.init(name: "cycle", value: cycle))
                var endpoint = Endpoint(host: api.openSecretHost,
                                        path: api.openSecretPath,
                                        httpMethod: .GET)
                endpoint.queryItems.append(contentsOf: queryItems)

                return endpoint
            }
        }
    }


}

