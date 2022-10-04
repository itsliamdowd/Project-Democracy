//
//  OpenSecretsModel.swift
//  Democracy
//
//  Created by Liam Dowd on 10/3/22.
//

//   let welcome10 = try Welcome10(json)

import Foundation

// MARK: - Welcome10
struct Welcome10 {
    let response: Response
}

// MARK: - Response
struct Response {
    let legislator: [Legislator]
}

// MARK: - Legislator
struct Legislator {
    let cid, firstlast, lastname: String
    let party: Party
    let office: String
    let gender: Gender
    let firstElected, exitCode: String
    let comments: Comments
    let phone, fax: String
    let website: String
    let webform: String
    let congressOffice, bioguideID, votesmartID, feccandid: String
    let twitterID: String
    let youtubeURL: String
    let facebookID, birthdate: String
}

enum Comments {
    case appointedToSenate1202021
    case empty
    case resigned132022
    case resignedToBecomeVicePresident
    case retiringAtEndOf117ThCongress
    case runningForMayorOfLosAngeles
}

enum Gender {
    case f
    case m
}

enum Party {
    case d
    case r
}
