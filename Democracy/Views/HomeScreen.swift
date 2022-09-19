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

extension HomeScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button")
        print(electionInfo[indexPath.row])
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ElectionScreen") as? ElectionScreen {
                #warning("Need to pass in election data")
                //vc.candidates = electionInfo[indexPath.row].districts.flatMap
                self.present(vc, animated: true)
            }
        }
    }
}

extension HomeScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return electionInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stateElections.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = electionInfo[indexPath.row].date.formatted(date: .long,
                                                                          time: .omitted)
        return cell
    }
}

class HomeScreen: UIViewController {
    var electionInfo = [BallotpediaElection]()

    @IBOutlet weak var electionDate: UILabel!
    @IBOutlet var stateElections: UITableView!
    @IBOutlet var conversationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to home screen")
        UserDefaults.standard.set("true", forKey: "loggedIn")
        stateElections.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateElections.dataSource = self
        stateElections.delegate = self
        conversationButton.layer.cornerRadius = 15

        if  let latitude = UserDefaults.standard.string(forKey: "latitude"),
            let longitude = UserDefaults.standard.string(forKey: "longitude") {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(latitude)!),
                                                  longitude: CLLocationDegrees(Double(longitude)!))
            let request = Endpoint.getAPI(from: .ballotpediaElectionInfo(location: location))

            URLSession.shared.codableTask(with: request) {[weak self] model in
                typealias c = Constants.JSON
                let electionsJson = model?[c.data][c.elections].array ?? []
                let elections: [BallotpediaElection] = electionsJson.compactMap {election in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let date = formatter.date(from: election[c.date].stringValue)

                    let districtsJson = election[c.districts].array ?? []
                    let districts: [BallotpediaElection.District] = districtsJson.compactMap {
                        let racesJson = $0[c.races].array ?? []
                        let races: [BallotpediaElection.Race] = racesJson.compactMap {
                            let rawLevel = $0[c.office][c.level].stringValue
                            guard let level = BallotpediaElection.ElectionLevel(rawValue: rawLevel.lowercased())
                            else {
                                return nil
                            }

                            let name = $0[c.office][c.name].stringValue
                            let candidatesJson = $0[c.candidates].array ?? []
                            let candidates: [BallotpediaElection.Candidate] = candidatesJson.map {
                                let name = $0[c.person][c.name].stringValue
                                let party = $0[c.party].array?.first?[c.name].stringValue
                                let imageUrl = $0[c.person][c.image][c.url].stringValue
                                return BallotpediaElection.Candidate(name: name,
                                                                     party: party,
                                                                     imageUrl: URL(string: imageUrl))
                            }
                            return BallotpediaElection.Race(name: name, level: level, candidates: candidates)
                        }
                        return BallotpediaElection.District(name: $0[c.name].stringValue, type: $0[c.type].stringValue, races: races)
                    }
                    guard let date = date else {
                        return nil
                    }
                    return BallotpediaElection(date: date, districts: districts)

                }
                guard let encodedElectionInfo = try? JSONEncoder().encode(self?.electionInfo)
                else {
                    preconditionFailure("Failured to encode election info for UserDefaults.")
                }
                UserDefaults.standard.set(encodedElectionInfo, forKey: "electionInfo")

                DispatchQueue.main.async {[weak self] in
                    self?.electionInfo = elections
                    self?.stateElections.reloadData()
                }

            }
        }

        else {
            print("Error")
        }

    }
    
    //Get api data for next election date
    //self.electionDate.text = "Election Date: " + electionDate
    

    //self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
    //print("refreshed")
    //DispatchQueue.main.async { self.stateElections.reloadData() }
    //print("Laguna Niguel")
    //UserDefaults.standard.set(citycountrydata, forKey: "city")

}


