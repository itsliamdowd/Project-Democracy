//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//
import UIKit
import SDWebImage

extension ElectionScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected a candidate")
        var candidateID = ""
        //Concurrent requests
        let group = DispatchGroup()
        group.enter()
        for openSecretsCandidate in openSecretsData {
            if openSecretsCandidate.firstlast == self.candidates[indexPath.row].name {
                candidateID = openSecretsCandidate.cid
                print("Found a match")
                //Make API call with candidate ID value to get financing info
            }
        }
        var imageUrl = self.candidates[indexPath.row].imageUrl
        SDWebImageManager.shared.loadImage(
                with: imageUrl,
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let vc = storyboard.instantiateViewController(withIdentifier: "CandidateScreen") as? CandidateScreen {
                            vc.candidate = self.candidates[indexPath.row]
                            vc.candidates = self.candidates
                            vc.homescreendata = self.homescreendata
                            vc.electionNameData = self.electionNameData
                            vc.candidateID = candidateID
                            self.present(vc, animated: true)
                        }
                    }
        }
        group.leave()
        group.notify(queue: .main) {
            print("Requests finished")
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
    var homescreendata = [BallotpediaElection]()
    var electionNameData = ""
    var openSecretsData = [OpenSecretsModel]()
    
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
        if self.electionNameData != nil {
            self.electionName.text = self.electionNameData
        }
        else {
            print("Error")
            self.electionName.text = "Election"
        }
        candidateTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        candidateTable.dataSource = self
        candidateTable.delegate = self
    }
}
