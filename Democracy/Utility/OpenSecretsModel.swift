//
//  OpenSecretsModel.swift
//  Democracy
//
//  Created by Liam Dowd on 10/3/22.
//


import Foundation

struct OpenSecretsModel: Codable {
    let cid, firstlast, lastname: String
    let party: String
    let office: String
    let gender: String
    let firstElected, exitCode: String
    let comments: String
    let phone, fax: String
    let website: String
    let webform: String
    let congressOffice, feccandid: String
    let votesmartId: String
    let bioguideId: String
    let twitterId: String
    let youtubeUrl: String
    let facebookId: String
    let birthdate: String

}

