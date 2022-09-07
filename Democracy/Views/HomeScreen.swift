//
//  ViewController.swift
//  Democracy
//
//  Created by Liam Dowd on 8/24/22.
//

import UIKit
import MapKit
import CoreLocation

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
    
    @IBOutlet var stateElections: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to home screen")
        UserDefaults.standard.set("true", forKey: "loggedIn")
        stateElections.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateElections.dataSource = self
        stateElections.delegate = self
        

        if  let latitude = UserDefaults.standard.string(forKey: "latitude"),
            let longitude = UserDefaults.standard.string(forKey: "longitude") {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(latitude)!),
                                                  longitude: CLLocationDegrees(Double(longitude)!))
            let request = Endpoint.getAPI(from: .ballotpediaElectionInfo(location: location))
            fetchData(api: request) {(success, errorDescription, data) in
                print(String(data: data!, encoding: .utf8))
            }
        }
        else {
            print("Error")
        }

    }

    func fetchData(api: Endpoint,
                   completion: @escaping  (Bool, String?, Data?) -> Void) {
        URLSession.shared.dataTask(with: api.request) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data
            else {
                let error = error?.localizedDescription ?? ""
                completion(false, error, nil)
                return
            }
            completion(true, nil, data)
        }.resume()
    }
    

    //self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
    //print("refreshed")
    //DispatchQueue.main.async { self.stateElections.reloadData() }
    //print("Laguna Niguel")
    //UserDefaults.standard.set(citycountrydata, forKey: "city")

}
