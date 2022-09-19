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

        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
                vc.candidate = self.candidates[indexPath.row]
                self.present(vc, animated: true)
            }
        }
    }
}

extension ElectionScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = candidateTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = candidates[indexPath.row].name
        return cell
    }
}

class ElectionScreen: UIViewController {
    
    var candidates = [BallotpediaElection.Candidate]()
    
    @IBOutlet var electionName: UILabel!
    @IBOutlet var candidateTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
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
