//
//  Constants.swift
//  Democracy
//
//  Created by Jevon Mao on 9/3/22.
//

import Foundation


struct Constants {
    struct API {
        //MARK: BallotPedia
        static let ballotpediaHost = "api4.ballotpedia.org"
        static let ballotpediaPath = "/myvote_redistricting"
        static let longtitudeLabel = "long"
        static let latitudeLabel = "lat"
        static let volunteerLabel = "include_volunteer"
        static let ballotpediaOriginValue = "capacitor://myvote.org"

        //MARK: VoterBase
        static let voterbaseHost = "api.voterbase.com"
        static let voterbasePath = "elections"
        static let addressLabel = "address"

    }
}
