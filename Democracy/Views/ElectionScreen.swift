//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

extension ElectionScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected a button")
        //TODO: Implement logic for candidate screen, need to show multiple candidates
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
//                vc.candidate = self.candidates[indexPath.row]
//                vc.candidates = self.racesArray[indexPath.row].candidates
//                vc.homescreendata = self.homescreendata
//                self.present(vc, animated: true)
//            }
//        }
    }
}

extension ElectionScreen: UITableViewDataSource {
    // Provide total number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        racesGroups.count
    }

    // Provide number of rows, given a particular section's index
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        racesGroups[section].races.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = candidateTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Get desired race's name by section index, then row index
        cell.textLabel?.text = racesGroups[indexPath.section].races[indexPath.row].name
        return cell
    }

    // Provide title given a particular section's index
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        racesGroups[section].districtName
    }
}

class ElectionScreen: UIViewController {
    // Organize data for table sections structure
    typealias RaceGroups = [(districtName: String, races: [BallotpediaElection.Race])]
    private var racesGroups: RaceGroups {
        districts.map {
            ($0.name, $0.races) // Tuple containing district name, and all its races
        }
    }
    var districts = [BallotpediaElection.District]()
    var homescreendata = [BallotpediaElection]()
    
    @IBOutlet var electionName: UILabel!
    @IBOutlet var candidateTable: UITableView!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as? HomeScreen {
                vc.homescreendata = self.homescreendata
                self.present(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
        print("ballotpedia")
//        if UserDefaults.standard.string(forKey: "electionName") != nil {
//            self.electionName.text = UserDefaults.standard.string(forKey: "electionName")
//        }
//        else {
//            print("Error")
//            self.electionName.text = "President"
//        }
        candidateTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        candidateTable.dataSource = self
        candidateTable.delegate = self
    }

}
