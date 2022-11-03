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
import SDWebImage

//Needs to show candidates for specific race
extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        DispatchQueue.main.async { [self] in
            //Sets index to large value so that it dosen't reload data
            UserDefaults.standard.set(5, forKey: "index")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if self.electionDisplayStyle.selectedSegmentIndex == 0 {
                if let vc = storyboard.instantiateViewController(withIdentifier: "ElectionScreen") as? ElectionScreen {
                    vc.candidates = self.racesGroups[indexPath.section].races[indexPath.row].candidates
                    vc.level = self.racesGroups[indexPath.section].races[indexPath.row].level
                    vc.homescreendata = self.electionInfo
                    vc.electionNameData = self.racesGroups[indexPath.section].races[indexPath.row].name
                    vc.allCandidates = self.allCandidates
                    self.present(vc, animated: true)
                }
            }
            else {
                var displayList = self.getActiveList()
                SDWebImageManager.shared.loadImage(
                    with: displayList[indexPath.section].candidates[indexPath.row].imageUrl,
                    options: .highPriority,
                    progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                        DispatchQueue.main.async {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
                                vc.candidate = displayList[indexPath.section].candidates[indexPath.row]
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
    }
}

extension HomeScreen: UITableViewDataSource {
    // Provide total number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // Segmented toggle between races and candidates
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            return racesGroups.count
        }
        if electionDisplayStyle.selectedSegmentIndex == 1 {
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups.count
                case 1:
                    return republicanArray.count
                case 2:
                    return democratArray.count
                case 3:
                    return otherArray.count
                default:
                    return candidateGroups.count
                }
        }
        else {
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups.count
                case 1:
                    return republicanArray.count
                case 2:
                    return democratArray.count
                case 3:
                    return otherArray.count
                default:
                    return candidateGroups.count
                }
        }
    }

    // Provide number of rows, given a particular section's index
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            return racesGroups[section].races.count
        }
        if electionDisplayStyle.selectedSegmentIndex == 1 {
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups[section].candidates.count
                case 1:
                    return republicanArray[section].candidates.count
                case 2:
                    return democratArray[section].candidates.count
                case 3:
                    return otherArray[section].candidates.count
                default:
                    return candidateGroups[section].candidates.count
                }
        }
        else {
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups[section].candidates.count
                case 1:
                    return republicanArray[section].candidates.count
                case 2:
                    return democratArray[section].candidates.count
                case 3:
                    return otherArray[section].candidates.count
                default:
                    return candidateGroups[section].candidates.count
                }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateElections.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if electionDisplayStyle.selectedSegmentIndex == 0 {
            // Get desired race's name by section index, then row index
            cell.textLabel?.text = racesGroups[indexPath.section].races[indexPath.row].name
        }
        else {
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    cell.textLabel?.text = candidateGroups[indexPath.section].candidates[indexPath.row].name
                case 1:
                    cell.textLabel?.text = republicanArray[indexPath.section].candidates[indexPath.row].name
                case 2:
                    cell.textLabel?.text = democratArray[indexPath.section].candidates[indexPath.row].name
                case 3:
                    cell.textLabel?.text = otherArray[indexPath.section].candidates[indexPath.row].name
                default:
                    cell.textLabel?.text = candidateGroups[indexPath.section].candidates[indexPath.row].name
                }
        }
        return cell
    }

    //Provide alphabet sorting for candidate view
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if electionDisplayStyle.selectedSegmentIndex == 1 {
            partySwitcher.isHidden = false
            if candidateGroups.isEmpty == false {
                func cacheImages() {
                    for candidate in allCandidates {
                        SDWebImageManager.shared.loadImage(
                            with: candidate.imageUrl,
                            options: .highPriority,
                            progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                        }
                    }
                }
                cacheImages()
                switch(partySwitcher.selectedSegmentIndex) {
                    case 0:
                        return candidateGroups.map{$0.letter}
                    case 1:
                        return republicanArray.map{$0.letter}
                    case 2:
                        return democratArray.map{$0.letter}
                    case 3:
                        return otherArray.map{$0.letter}
                     default:
                        return candidateGroups.map{$0.letter}
                     }
            }
            else {
                typealias CandidateGroups = [(letter: String, candidates: [BallotpediaElection.Candidate])]
                // Convert candidate array to dictionary, sorted by alphabetical order
                var candidateGroups: CandidateGroups {
                        let candidateDictionary = Dictionary(grouping: allCandidates,
                                                           by: {$0.name.first!})
                        let groups = candidateDictionary.keys.sorted().map {letter in
                            (String(letter), candidateDictionary[letter]!)
                        }
                        return groups
                }
                var republicanArray: CandidateGroups {
                    let filteredCandidates = candidateGroups.filter{$0.candidates[0].party == "Republican Party"}
                    return filteredCandidates
                }
                var democratArray: CandidateGroups {
                    let filteredCandidates = candidateGroups.filter{$0.candidates[0].party == "Democratic Party"}
                    return filteredCandidates
                }
                var otherArray: CandidateGroups {
                    let filteredCandidates = candidateGroups.filter{$0.candidates[0].party != "Democratic Party" && $0.candidates[0].party != "Republican Party"}
                    return filteredCandidates
                }
                switch(partySwitcher.selectedSegmentIndex) {
                    case 0:
                        return candidateGroups.map{$0.letter}
                    case 1:
                        return republicanArray.map{$0.letter}
                    case 2:
                        return democratArray.map{$0.letter}
                    case 3:
                        return otherArray.map{$0.letter}
                    default:
                        return candidateGroups.map{$0.letter}
                    }
            }
        }
        else {
            return nil
        }
    }
    
    // Provide title given a particular section's index
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if electionDisplayStyle.selectedSegmentIndex == 0 {
            partySwitcher.isHidden = true
            incumbentButton.isHidden = false
            stateElections.frame = CGRect(x: 23, y: 206, width: 382, height: 532)
            return racesGroups[section].districtName
        }
        else if electionDisplayStyle.selectedSegmentIndex == 1 {
            incumbentButton.isHidden = true
            stateElections.frame = CGRect(x: 23, y: 244, width: 382, height: 600)
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups[section].letter
                case 1:
                    return republicanArray[section].letter
                case 2:
                    return democratArray[section].letter
                case 3:
                    return otherArray[section].letter
                default:
                    return candidateGroups[section].letter
                }
        }
        else {
            stateElections.frame = CGRect(x: 23, y: 244, width: self.view.frame.width, height: 614)
            switch(partySwitcher.selectedSegmentIndex) {
                case 0:
                    return candidateGroups[section].letter
                case 1:
                    return republicanArray[section].letter
                case 2:
                    return democratArray[section].letter
                case 3:
                    return otherArray[section].letter
                default:
                    return candidateGroups[section].letter
                }
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

    private var republicanArray: CandidateGroups {
        var republicans = [BallotpediaElection.Candidate]()
        for candidateGroup in candidateGroups {
            for candidate in candidateGroup.candidates {
                if candidate.party == "Republican Party" {
                    republicans.append(candidate)
                }
            }
        }
        let republicanDictionary = Dictionary(grouping: republicans,
                                           by: {$0.name.first!})
        let republicanGroups = republicanDictionary.keys.sorted().map {letter in
            (String(letter), republicanDictionary[letter]!)
        }
        return republicanGroups
    }
    private var democratArray: CandidateGroups {
        var democrats = [BallotpediaElection.Candidate]()
        for candidateGroup in candidateGroups {
            for candidate in candidateGroup.candidates {
                if candidate.party == "Democratic Party" {
                    democrats.append(candidate)
                }
            }
        }
        let democratDictionary = Dictionary(grouping: democrats,
                                           by: {$0.name.first!})
        let democratGroups = democratDictionary.keys.sorted().map {letter in
            (String(letter), democratDictionary[letter]!)
        }
        return democratGroups
    }
    private var otherArray: CandidateGroups {
        var other = [BallotpediaElection.Candidate]()
        for candidateGroup in candidateGroups {
            for candidate in candidateGroup.candidates {
                if candidate.party != "Republican Party" && candidate.party != "Democratic Party" {
                    other.append(candidate)
                }
            }
        }
        let otherDictionary = Dictionary(grouping: other,
                                           by: {$0.name.first!})
        let otherGroups = otherDictionary.keys.sorted().map {letter in
            (String(letter), otherDictionary[letter]!)
        }
        return otherGroups
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
    var allCandidates = [BallotpediaElection.Candidate]()
    var arrayOfRepresentatives = [Current.Representative]()

    @IBOutlet weak var electionDate: UILabel!
    @IBOutlet var stateElections: UITableView!
    @IBOutlet var electionDisplayStyle: UISegmentedControl!
    @IBOutlet weak var partySwitcher: UISegmentedControl!
    @IBOutlet weak var incumbentButton: UIButton!
    
    @IBAction func incumbentButtonPressed(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if arrayOfRepresentatives == [] {
            var semaphore = DispatchSemaphore (value: 0)
            var urlForData = ""
            var lat = UserDefaults.standard.string(forKey: "latitude")
            var lon = UserDefaults.standard.string(forKey: "longitude")
            urlForData = "https://project-democracy.herokuapp.com/api/getRepresentatives/" + lat! + "/" + lon! + "/"
            var urlString = urlForData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            var request = URLRequest(url: URL(string: urlString!)!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    semaphore.signal()
                    return
                }
                let representatives = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: [String: String]]
                for representative in representatives {
                    let name = representative.key
                    let address = representative.value["address"]
                    let phone = representative.value["phone"]
                    let url = representative.value["url"]
                    let party = representative.value["party"]
                    let level = representative.value["type"]
                    var image = ""
                    if representative.value["image"] != nil {
                        image = representative.value["image"]!
                    }
                    var twitter = ""
                    if representative.value["twitter"] != nil {
                        twitter = representative.value["twitter"]!
                    }
                    var facebook = ""
                    if representative.value["facebook"] != nil {
                        facebook = representative.value["facebook"]!
                    }
                    var youtube = ""
                    if representative.value["youtube"] != nil {
                        youtube = representative.value["youtube"]!
                    }
                    var representativeData = Current.Representative(name: name, level: level, party: party!, phone: phone!, address: address!, url: URL(string: url!), imageUrl: URL(string: image), sectors: ["": ""], organizations: ["": ""], twitterUrl: twitter, facebookUrl: facebook, youtubeUrl: youtube)
                    self.arrayOfRepresentatives.append(representativeData)
                }
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()
        }
        else {
            print("Information already saved")
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "MyRepresentativesScreen") as? MyRepresentativesScreen {
            vc.homescreendata = self.electionInfo
            vc.allCandidates = self.allCandidates
            vc.arrayOfRepresentatives = self.arrayOfRepresentatives
            self.present(vc, animated: true)
        }
    }
    
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
    
    func getActiveList() -> CandidateGroups {
        switch(self.partySwitcher.selectedSegmentIndex) {
            case 0:
                return candidateGroups
            case 1:
                return republicanArray
            case 2:
                return democratArray
            case 3:
                return otherArray
            default:
                return candidateGroups
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
        incumbentButton.layer.cornerRadius = 15
        loadElectionData()
        partySwitcher.removeAllSegments()
        partySwitcher.insertSegment(withTitle: "All", at: 0, animated: false)
        partySwitcher.insertSegment(withTitle: "Republican", at: 1, animated: false)
        partySwitcher.insertSegment(withTitle: "Democrat", at: 2, animated: false)
        partySwitcher.insertSegment(withTitle: "Other", at: 3, animated: false)
        partySwitcher.selectedSegmentIndex = 0
        partySwitcher.isHidden = true
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
