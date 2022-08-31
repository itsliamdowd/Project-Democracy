//
//  ViewController.swift
//  Democracy
//
//  Created by Liam Dowd on 8/24/22.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let success: Bool
    let data: DataClass
    let message: JSONNull?
}

// MARK: - DataClass
struct DataClass: Codable {
    let longitude, latitude: Double
    let districts: [DataDistrict]
    let pollInfo: [PollInfo]
    let elections: [Election]
    let volunteerElections: JSONNull?

    enum CodingKeys: String, CodingKey {
        case longitude, latitude, districts
        case pollInfo = "poll_info"
        case elections
        case volunteerElections = "volunteer_elections"
    }
}

// MARK: - DataDistrict
struct DataDistrict: Codable {
    let id: Int
    let name, type: String
    let covered: Bool
    let url: String
    let ocdid: String?
    let isIndependentCity: Bool
    let ncesID, geoID: String?
    let tags: JSONNull?
    let state: State
    let created, updated: String
    let districtDescription, parentDistrict: JSONNull?
    let startDate: String
    let endDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, type, covered, url, ocdid
        case isIndependentCity = "is_independent_city"
        case ncesID = "nces_id"
        case geoID = "geo_id"
        case tags, state, created, updated
        case districtDescription = "description"
        case parentDistrict = "parent_district"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

enum State: String, Codable {
    case ca = "CA"
    case us = "US"
}

// MARK: - Election
struct Election: Codable {
    let date: String
    let candidateListsComplete: Bool
    let votingInfo: [VotingInfo]
    let districts: [ElectionDistrict]

    enum CodingKeys: String, CodingKey {
        case date
        case candidateListsComplete = "candidate_lists_complete"
        case votingInfo = "voting_info"
        case districts
    }
}

// MARK: - ElectionDistrict
struct ElectionDistrict: Codable {
    let id: Int
    let name, type: String
    let disclaimers: [Disclaimer]?
    let permanentDisclaimers: JSONNull?
    let ballotMeasures: [BallotMeasure]?
    let races: [Race]

    enum CodingKeys: String, CodingKey {
        case id, name, type, disclaimers
        case permanentDisclaimers = "permanent_disclaimers"
        case ballotMeasures = "ballot_measures"
        case races
    }
}

// MARK: - BallotMeasure
struct BallotMeasure: Codable {
    let id: Int
    let name: String
    let url: String
    let status, type: String
    let district: Int
    let yesVote, noVote, officialTitle, electionDate: String

    enum CodingKeys: String, CodingKey {
        case id, name, url, status, type, district
        case yesVote = "yes_vote"
        case noVote = "no_vote"
        case officialTitle = "official_title"
        case electionDate = "election_date"
    }
}

// MARK: - Disclaimer
struct Disclaimer: Codable {
    let id, sort: Int
    let text: String
    let district, electionDate: Int
    let created, updated, date, type: String
    let candidateListsComplete: Bool

    enum CodingKeys: String, CodingKey {
        case id, sort, text, district
        case electionDate = "election_date"
        case created, updated, date, type
        case candidateListsComplete = "candidate_lists_complete"
    }
}

// MARK: - Race
struct Race: Codable {
    let id: Int
    let office: Office
    let officeDistrict: Int
    let url: String
    let numberOfSeats, year: Int
    let type: RaceType
    let isMarquee: Bool
    let officePosition: String?
    let candidates: [Candidate]

    enum CodingKeys: String, CodingKey {
        case id, office
        case officeDistrict = "office_district"
        case url
        case numberOfSeats = "number_of_seats"
        case year, type
        case isMarquee = "is_marquee"
        case officePosition = "office_position"
        case candidates
    }
}

// MARK: - Candidate
struct Candidate: Codable {
    let id, race: Int
    let runningMate: JSONNull?
    let partyAffiliation: [PartyAffiliation]
    let person: Person
    let isIncumbent: Bool
    let campaignFacebookURL: String?
    let campaignWebsiteURL: String?
    let campaignTwitterURL: String?
    let isWriteIn, withdrewStillOnBallot: Bool
    let runningMateID: JSONNull?
    let biography, keyMessage1, keyMessage2, keyMessage3: String?

    enum CodingKeys: String, CodingKey {
        case id, race
        case runningMate = "running_mate"
        case partyAffiliation = "party_affiliation"
        case person
        case isIncumbent = "is_incumbent"
        case campaignFacebookURL = "campaign_facebook_url"
        case campaignWebsiteURL = "campaign_website_url"
        case campaignTwitterURL = "campaign_twitter_url"
        case isWriteIn = "is_write_in"
        case withdrewStillOnBallot = "withdrew_still_on_ballot"
        case runningMateID = "running_mate_id"
        case biography
        case keyMessage1 = "key_message_1"
        case keyMessage2 = "key_message_2"
        case keyMessage3 = "key_message_3"
    }
}

// MARK: - PartyAffiliation
struct PartyAffiliation: Codable {
    let id: Int
    let name: Name
    let url: String
}

enum Name: String, Codable {
    case democraticParty = "Democratic Party"
    case nonpartisan = "Nonpartisan"
    case republicanParty = "Republican Party"
}

// MARK: - Person
struct Person: Codable {
    let id: Int
    let name, firstName, lastName: String
    let image: Image?
    let url: String
    let contactWebsite: JSONNull?
    let contactFacebook: String?
    let contactTwitter: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case firstName = "first_name"
        case lastName = "last_name"
        case image, url
        case contactWebsite = "contact_website"
        case contactFacebook = "contact_facebook"
        case contactTwitter = "contact_twitter"
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int
    let name: String
    let url, thumbnail: String
    let type: ImageType
    let width, height, size: Int
    let dateUploaded: String

    enum CodingKeys: String, CodingKey {
        case id, name, url, thumbnail, type, width, height, size
        case dateUploaded = "date_uploaded"
    }
}

enum ImageType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imageJpg = "image/jpg"
    case imagePNG = "image/png"
}

// MARK: - Office
struct Office: Codable {
    let id: Int
    let name: String
    let level: Level
    let branch: Branch
    let chamber: String?
    let isPartisan: IsPartisan
    let type: String?
    let group: Int?
    let seat: String?
    let url: String
    let officeDistrict: Int

    enum CodingKeys: String, CodingKey {
        case id, name, level, branch, chamber
        case isPartisan = "is_partisan"
        case type, group, seat, url
        case officeDistrict = "office_district"
    }
}

enum Branch: String, Codable {
    case executive = "Executive"
    case judicial = "Judicial"
    case legislative = "Legislative"
}

enum IsPartisan: String, Codable {
    case nonpartisanAll = "Nonpartisan all"
    case partisanAll = "Partisan all"
}

enum Level: String, Codable {
    case federal = "Federal"
    case local = "Local"
    case state = "State"
}

enum RaceType: String, Codable {
    case regular = "Regular"
    case special = "Special"
}

// MARK: - VotingInfo
struct VotingInfo: Codable {
    let election: Int
    let registrationDeadlineInperson, registrationDeadlineMail, registrationDeadlineMailType: String
    let onlineRegistration: JSONNull?
    let registrationDeadlineOnline: String
    let registrationURLEn: String
    let electionDayRegistration: JSONNull?
    let earlyVotingSource: String
    let inpersonRequestDeadline: String
    let eligibilityLimits: JSONNull?
    let eligibilityURLEn: String
    let mailRequestDeadline, mailTypeRequestDeadline, onlineReturnDeadline, requestURLEn: JSONNull?
    let inpersonReturnDeadline, mailReturnDeadline, mailTypeReturnDeadline: String
    let mailReturnDeadlineSecondary, mailTypeReturnDeadlineSecondary: JSONNull?
    let polltimes: String
    let voterIDAllvoters, requiredMaterials, voterIDSourceEn: JSONNull?

    enum CodingKeys: String, CodingKey {
        case election
        case registrationDeadlineInperson = "registration_deadline_inperson"
        case registrationDeadlineMail = "registration_deadline_mail"
        case registrationDeadlineMailType = "registration_deadline_mail_type"
        case onlineRegistration = "online_registration"
        case registrationDeadlineOnline = "registration_deadline_online"
        case registrationURLEn = "registration_url_en"
        case electionDayRegistration = "election_day_registration"
        case earlyVotingSource = "early_voting_source"
        case inpersonRequestDeadline = "inperson_request_deadline"
        case eligibilityLimits = "eligibility_limits"
        case eligibilityURLEn = "eligibility_url_en"
        case mailRequestDeadline = "mail_request_deadline"
        case mailTypeRequestDeadline = "mail_type_request_deadline"
        case onlineReturnDeadline = "online_return_deadline"
        case requestURLEn = "request_url_en"
        case inpersonReturnDeadline = "inperson_return_deadline"
        case mailReturnDeadline = "mail_return_deadline"
        case mailTypeReturnDeadline = "mail_type_return_deadline"
        case mailReturnDeadlineSecondary = "mail_return_deadline_secondary"
        case mailTypeReturnDeadlineSecondary = "mail_type_return_deadline_secondary"
        case polltimes
        case voterIDAllvoters = "voter_id_allvoters"
        case requiredMaterials = "required_materials"
        case voterIDSourceEn = "voter_id_source_en"
    }
}

// MARK: - PollInfo
struct PollInfo: Codable {
    let pollsOpen, pollsClose: String
    let pollInfoDescription: JSONNull?
    let pollingLocations: String

    enum CodingKeys: String, CodingKey {
        case pollsOpen = "polls_open"
        case pollsClose = "polls_close"
        case pollInfoDescription = "description"
        case pollingLocations = "polling_locations"
    }
}

// MARK: - Encode/decode helpers

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

extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button...")
        print(data[indexPath.row])
        UserDefaults.standard.set(data[indexPath.row], forKey: "electionName")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ElectionScreen")
            self.present(vc, animated: true)
        }
    }
}

extension HomeScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateElections.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

class HomeScreen: UIViewController {
    
    var data = ["Loading...", "Loading...", "Loading...", "Loading...", "Loading..."]
    
    @IBOutlet var stateElections: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("true", forKey: "loggedIn")
        stateElections.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateElections.dataSource = self
        stateElections.delegate = self
        
        var semaphore = DispatchSemaphore (value: 0)
        var latitude = UserDefaults.standard.string(forKey: "latitude")
        var longitude = UserDefaults.standard.string(forKey: "longitude")
        if (latitude != nil) && (longitude != nil) {
            var URLBuilder = "https://api4.ballotpedia.org/myvote_redistricting?long=" + longitude! + "&lat=" + latitude! + "&include_volunteer=true"
            var request = URLRequest(url: URL(string: URLBuilder)!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("capacitor://myvote.org", forHTTPHeaderField: "Origin")

            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
              }
              print(String(data: data, encoding: .utf8)!)
              semaphore.signal()
            }

            task.resume()
            semaphore.wait()
        }
        else {
            print("Error")
        }

    }
    

    //self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
    //print("refreshed")
    //DispatchQueue.main.async { self.stateElections.reloadData() }
    //print("Laguna Niguel")
    //UserDefaults.standard.set(citycountrydata, forKey: "city")

}
