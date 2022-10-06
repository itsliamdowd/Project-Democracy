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
        static let voterbasePath = "/elections"
        static let addressLabel = "address"

        //MARK: OpenSecrets
        static let openSecretHost = "www.opensecrets.org"
        static let openSecretPath = "/api"
    }

    struct JSON {
        static let data = "data"
        static let elections = "elections"
        static let date = "date"
        static let districts = "districts"
        static let name = "name"
        static let type = "type"
        static let races = "races"
        static let office = "office"
        static let level = "level"
        static let candidates = "candidates"
        static let party = "party_affiliation"
        static let person = "person"
        static let url = "url"
        static let image = "image"
        static let isIncumbant = "is_incumbent"
        static let websiteUrl = "campaign_website_" + url
        static let twitterUrl = "campaign_twitter_" + url
        static let facebookUrl = "campaign_facebook_url" + url
        static let biography = "biography"
    }
}
