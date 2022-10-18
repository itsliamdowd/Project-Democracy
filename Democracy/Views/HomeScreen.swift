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
import SwiftyJSON

//Needs to show candidates for specific race
extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        DispatchQueue.main.async {
            //Sets index to large value so that it dosen't reload data
            UserDefaults.standard.set(5, forKey: "index")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if self.electionDisplayStyle.selectedSegmentIndex == 0 {
                if let vc = storyboard.instantiateViewController(withIdentifier: "ElectionScreen") as? ElectionScreen {
                    vc.candidates = self.racesGroups[indexPath.section].races[indexPath.row].candidates
                    print(self.racesGroups[indexPath.section].races[indexPath.row].level)
                    vc.level = self.racesGroups[indexPath.section].races[indexPath.row].level
                    vc.homescreendata = self.electionInfo
                    vc.electionNameData = self.racesGroups[indexPath.section].races[indexPath.row].name
                    vc.openSecretsData = self.openSecretsData
                    self.present(vc, animated: true)
                }
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
                    vc.candidate = self.candidateGroups[indexPath.section].candidates[indexPath.row]
                    vc.candidates = self.allCandidates
                    vc.homescreendata = self.homescreendata
                    vc.electionNameData = ""
                    for indexPath in tableView.indexPathsForSelectedRows ?? [] {
                        self.stateElections.deselectRow(at: indexPath, animated: true)
                    }
                    self.present(vc, animated: true)
                }
            }
        }
    }
}

extension HomeScreen: UITableViewDataSource {
    // Provide total number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // Segmented toggle between races and candidates
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            return racesGroups.count
        }
        else {
            return candidateGroups.count
        }
    }

    // Provide number of rows, given a particular section's index
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            return racesGroups[section].races.count
        }
        else {
            return candidateGroups[section].candidates.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateElections.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if electionDisplayStyle.selectedSegmentIndex == 0 {
            // Get desired race's name by section index, then row index
            cell.textLabel?.text = racesGroups[indexPath.section].races[indexPath.row].name
        }
        else {
            cell.textLabel?.text = candidateGroups[indexPath.section].candidates[indexPath.row].name
        }
        return cell
    }

    //Provide alphabet sorting for candidate view
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if electionDisplayStyle.selectedSegmentIndex == 1 {
            return candidateGroups.map{$0.letter}
        }
        else {
            return nil
        }
    }

    // Provide title given a particular section's index
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            return racesGroups[section].districtName
        }
        else {
            return candidateGroups[section].letter
        }
    }
}

class HomeScreen: UIViewController {
    
    typealias RaceGroups = [(districtName: String, races: [BallotpediaElection.Race])]
    typealias CandidateGroups = [(letter: String, candidates: [BallotpediaElection.Candidate])]

    // Convert candidate array to dictionary, sorted by alphabetical order
    private var candidateGroups: CandidateGroups {
        let candidateDictionary = Dictionary(grouping: allCandidates,
                                           by: {$0.name.first!})
        let groups = candidateDictionary.keys.sorted().map {letter in
            (String(letter), candidateDictionary[letter]!)
        }
        return groups
    }

    private var racesGroups: RaceGroups {
        districts.map {
            ($0.name, $0.races) // Tuple containing district name and all its races
        }
    }
    
    var districts: [BallotpediaElection.District] {
        self.electionInfo.first?.districts ?? []
    }

    var electionInfo = [BallotpediaElection]()
    var homescreendata = [BallotpediaElection]()
    var openSecretsData = [OpenSecretsModel]()
    var allCandidates = [BallotpediaElection.Candidate]()

    @IBOutlet weak var electionDate: UILabel!
    @IBOutlet var stateElections: UITableView!
    @IBOutlet var conversationButton: UIButton!
    @IBOutlet var electionDisplayStyle: UISegmentedControl!
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set(1, forKey: "index")
            UserDefaults.standard.set("false", forKey: "loggedIn")
            UserDefaults.standard.set("", forKey: "longitude")
            UserDefaults.standard.set("", forKey: "latitude")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LocationScreen") as? LocationScreen
            self.present(vc!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to home screen")
        var existingIndex = UserDefaults.standard.integer(forKey: "index")
        existingIndex = existingIndex + 1
        print(existingIndex)
        UserDefaults.standard.set(existingIndex, forKey: "index")
        UserDefaults.standard.set("true", forKey: "loggedIn")
        if let cachedData = UserDefaults.standard.data(forKey: "electionInfo"),
           let electionDecoded = try? JSONDecoder().decode([BallotpediaElection].self, from: cachedData) {
            homescreendata = electionDecoded
            if existingIndex == 1 || existingIndex == 3 {
                homescreendata.removeAll()
            }
        }
        if UserDefaults.standard.string(forKey: "electionDate") != nil && self.electionDate.text == "Election Date:" {
            self.electionDate.text = UserDefaults.standard.string(forKey: "electionDate")
        }
        stateElections.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateElections.dataSource = self
        stateElections.delegate = self
        conversationButton.layer.cornerRadius = 15
        conversationButton.isHidden = true
        //Concurrent requests
        //let group = DispatchGroup()
        //group.enter()
        loadElectionData()
        //loadOpenSecrets()
        //group.leave()
        //group.notify(queue: .main) {
        //    print("requests finished")
        //}
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        stateElections.reloadData()
    }
}

//MARK: - API Networking
private extension HomeScreen {
    typealias c = Constants.JSON    // Easier access to JSON key constants

    //Constructs a network request using user location
    private func makeRequest() -> Endpoint? {
        guard UserDefaults.standard.string(forKey: "longitude") != nil &&
                UserDefaults.standard.string(forKey: "latitude") != nil &&
                homescreendata.count == 0
        else {
            return nil
        }
        let latitude = UserDefaults.standard.string(forKey: "latitude")
        let longitude = UserDefaults.standard.string(forKey: "longitude")
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(latitude!)!),
                                              longitude: CLLocationDegrees(Double(longitude!)!))
        let request = Endpoint.getAPI(from: .ballotpediaElectionInfo(location: location))
        return request
    }

    private func loadElectionData() {
        guard let request = makeRequest()
        else {
            //Prevent loading if there is existing cache
            if !homescreendata.isEmpty {
                electionInfo = homescreendata
                stateElections.reloadData()
            }
            return
        }
        URLSession.shared.codableTask(with: request) {[weak self] model in
            let elections = self?.parseElections(model) ?? [] // Extract desired information from JSON into our custom model
            // Saving cache to UserDefaults for future access
            guard let encodedElectionInfo = try? JSONEncoder().encode(elections)
            else {
                preconditionFailure("Failured to encode election info for UserDefaults.")
            }
            UserDefaults.standard.set(encodedElectionInfo, forKey: "electionInfo")
            DispatchQueue.main.async {[weak self] in
                self?.electionInfo = elections
                self?.stateElections.reloadData()
                self?.allCandidates = self?.parseCandidates(for: elections) ?? [] 
            }
        }
    }

    private func parseCandidates(for electionInfo: [BallotpediaElection]) -> [BallotpediaElection.Candidate] {
        let candidates = electionInfo.flatMap {
            $0.districts.flatMap {$0.races.flatMap{$0.candidates}}
        }
        var candidatesDict = Dictionary(grouping: candidates, by: {$0.name})
        // Get duplicated candidate names in dictionary
        let removingDuplicates = candidatesDict
            .filter { $1.count > 1 }

        for key in removingDuplicates.keys {
            // Remove all duplicates from original dictionary
            candidatesDict[key] = nil
            // Use length of debug description to determine which
            // duplicate contains more information
            let candidates = Dictionary(grouping: removingDuplicates[key]!, by: {($0 as? BallotpediaElection.Candidate).debugDescription})
            // Sort by debug description length
            let sorted = candidates.sorted { $0.key > $1.key }
            // Get candidate object with most information
            let candidate = Array(sorted.map({ $0.value })).first
            // Put that candidate back into original dictionary
            candidatesDict[key] = candidate

        }
        return candidatesDict.map{$0.value.first!}
    }

    // Top to bottom parsing for a deeply nested JSON API
    private func parseElections(_ model: JSON?) -> [BallotpediaElection] {
        let electionsJson = model?[c.data][c.elections].array ?? []
        let elections: [BallotpediaElection] = electionsJson.compactMap {election in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let date = formatter.date(from: election[c.date].stringValue)
            guard let date = date else {
                return nil
            }

            // Parse the nested districts
            let districts = parseDistricts(election)
            print(date)
            let dateString = formatter.string(from: date)
            var dateComponents = dateString.split(separator: " ")
            var dateComponentsTwo = dateComponents[0].components(separatedBy: "-")
            var dateForDisplay = dateComponentsTwo[1] + "/" + dateComponentsTwo[2] + "/" + dateComponentsTwo[0]
            dateForDisplay = dateForDisplay.replacingOccurrences(of: "/0", with: "/")
            if dateForDisplay.first == "0" {
                dateForDisplay.remove(at: dateForDisplay.startIndex)
            }
            print(dateForDisplay)
            var dateForElection = "Election Date: " + dateForDisplay
            DispatchQueue.main.async {
                self.electionDate.text = dateForElection
            }
            UserDefaults.standard.set(dateForElection, forKey: "electionDate")
            return BallotpediaElection(date: date, districts: districts)

        }

        return elections
    }

    private func parseDistricts(_ election: JSON) -> [BallotpediaElection.District] {
        let districtsJson = election[c.districts].array ?? []
        let districts: [BallotpediaElection.District] = districtsJson.compactMap {district in
            // Parse the deeper nested races
            let races = parseRaces(district)
            return BallotpediaElection.District(name: district[c.name].stringValue, type: district[c.type].stringValue, races: races)
        }

        return districts
    }

    private func parseRaces(_ district: JSON) -> [BallotpediaElection.Race] {
        let racesJson = district[c.races].array ?? []
        let races: [BallotpediaElection.Race] = racesJson.compactMap {race in
            // Office level, eg federal, state.etc
            let rawLevel = race[c.office][c.level].stringValue
            let name = race[c.office][c.name].stringValue

            // Convert raw string level to enum
            guard let level = BallotpediaElection.ElectionLevel(rawValue: rawLevel.lowercased())
            else {
                return nil
            }

            let candidates = parseCandidates(race)
            return BallotpediaElection.Race(name: name, level: level.rawValue, candidates: candidates)
        }

        return races
    }

    private func parseCandidates(_ race: JSON) -> [BallotpediaElection.Candidate] {
        let candidatesJson = race[c.candidates].array ?? []
        let candidates: [BallotpediaElection.Candidate] = candidatesJson.map {candidate in
            let name = candidate[c.person][c.name].stringValue
            let party = candidate[c.party].array?.first?[c.name].stringValue
            let imageUrl = candidate[c.person][c.image][c.url].stringValue
            let isIncumbent = candidate[c.isIncumbant].boolValue
            let facebookUrl = URL(string: candidate[c.facebookUrl].stringValue)
            let websiteUrl = URL(string: candidate[c.websiteUrl].stringValue)
            let twitterUrl = candidate[c.twitterUrl].stringValue
            let biography = candidate[c.biography].stringValue
            let phone = ""
            let address = ""
            let sectors = ["": ""]
            let organizations = ["": ""]
            
            return BallotpediaElection.Candidate(name: name,
                                                 party: party,
                                                 imageUrl: URL(string: imageUrl),
                                                 isIncumbent: isIncumbent,
                                                 facebookUrl: facebookUrl,
                                                 twitterUrl: twitterUrl,
                                                 websiteUrl: websiteUrl,
                                                 biography: biography,
                                                 phone: phone,
                                                 address: address,
                                                 sectors: sectors,
                                                 organizations: organizations)
        }

        return candidates
    }
}
    
private extension HomeScreen {
    private func loadOpenSecrets() {
        getGeocodeState {state in
            guard let state = state else {
                return
            }
            let endpoint = Endpoint.getAPI(from: .openSecrets(route: .getLegislator(state: state)))
            URLSession.shared.codableTask(with: endpoint) {[weak self] result in
                let legislators = result?["response"]["legislator"].array ?? []
                self?.openSecretsData = legislators.compactMap {candidate -> OpenSecretsModel? in
                    guard let info = try? candidate["@attributes"].rawData()
                    else {
                        return nil
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let model = try? decoder.decode(OpenSecretsModel.self, from: info)
                    return model
                }
            }
        }

    }

    private func getGeocodeState(completion: @escaping (String?) -> Void) {
        if UserDefaults.standard.string(forKey: "latitude") != nil && UserDefaults.standard.string(forKey: "longitude") != nil {
            let latitude = UserDefaults.standard.string(forKey: "latitude")
            let longitude = UserDefaults.standard.string(forKey: "longitude")
            let location = CLLocation(latitude: CLLocationDegrees(Double(latitude!)!), longitude: CLLocationDegrees(Double(longitude!)!))
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) {placemarks, _ in
                let state = placemarks?.first?.administrativeArea
                completion(state)
            }

        }
    }
}
