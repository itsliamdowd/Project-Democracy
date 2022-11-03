//
//  MyRepresentativesScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 10/30/22.
//

import UIKit
import SDWebImage

class MyRepresentativesScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var homescreendata = [BallotpediaElection]()
    var allCandidates = [BallotpediaElection.Candidate]()
    var arrayOfRepresentatives = [Current.Representative]()
    @IBOutlet weak var representatives: UITableView!
    
    var list = ["Loading", "Loading", "Loading", "Loading", "Loading", "Loading", "Loading", "Loading"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(list[indexPath.row])
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        SDWebImageManager.shared.loadImage(
            with: self.arrayOfRepresentatives[indexPath.row].imageUrl,
            options: .highPriority,
            progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let vc = storyboard.instantiateViewController(withIdentifier: "RepresentativeScreen") as? RepresentativeScreen {
                        vc.representative = self.arrayOfRepresentatives[indexPath.row]
                        vc.arrayOfRepresentatives = self.arrayOfRepresentatives
                        vc.homescreendata = self.homescreendata
                        vc.electionNameData = ""
                        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
                            self.representatives.deselectRow(at: indexPath, animated: true)
                        }
                        self.present(vc, animated: true)
                    }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen") as? HomeScreen {
                vc.homescreendata = self.homescreendata
                vc.allCandidates = self.allCandidates
                vc.arrayOfRepresentatives = self.arrayOfRepresentatives
                self.present(vc, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.arrayOfRepresentatives)
        list = self.arrayOfRepresentatives.map { $0.name }
        representatives.delegate = self
        representatives.dataSource = self
    }
}
