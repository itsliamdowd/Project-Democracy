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
        print("selected a button...")
        print(data[indexPath.row])
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

class HomeScreen: UIViewController, CLLocationManagerDelegate {
    
    var data = ["Loading...", "Loading...", "Loading...", "Loading...", "Loading..."]
    
    
    let locationManager = CLLocationManager()
    @IBOutlet var stateElections: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set("true", forKey: "loggedIn")
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        stateElections.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        stateElections.dataSource = self
        stateElections.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)
            var citycountrydata = city + ", " + country
            var stateElectionsArray = [String].self()
            var countyElectionsArray = [String].self()
            var localElectionsArray = [String].self()
            var federalElectionsArray = [String].self()
            switch citycountrydata {
                case "San Juan Capistrano, United States":
                    print("San Juan Capistrano")
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    //"U.S. Senate", "U.S. Representative in Congress",
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "Dana Point, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("Dana Point")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "Laguna Niguel, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("Laguna Niguel")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "Laguna Beach, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("Laguna Beach")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "San Clemente, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("San Clemente")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "Irvine, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("Irvine")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                case "Orange, United States":
                    self.data = ["State Senate", "State Assembly Member", "Governor", "Lieutenant Governor", "Secretary of State", "Controller", "Treasurer", "Attorney General", "Insurance Commissioner", "Member of State Board of Equalization", "State Superintendent of Public Instruction"]
                    print("refreshed")
                    DispatchQueue.main.async { self.stateElections.reloadData() }
                    print("Orange")
                    UserDefaults.standard.set(citycountrydata, forKey: "city")
                default:
                    print("Error")
            }
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }

}
