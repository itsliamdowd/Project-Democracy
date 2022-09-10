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
    
    var data = ["Loading", "Loading", "Loading", "Loading", "Loading"]
    
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

            URLSession.shared.codableTask(with: request) {model in
                print(model)
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


