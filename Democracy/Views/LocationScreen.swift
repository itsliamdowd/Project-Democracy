//
//  LocationScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationScreen: UIViewController, CLLocationManagerDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "longitude") == nil {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "latitude") == nil {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "longitude") != nil && UserDefaults.standard.string(forKey: "latitude") != nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
                self.present(vc, animated: true)
            }
        }
        else {
            print("Error")
        }
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else {
            print("Must provide location services to use feature")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.cornerRadius = 20
        searchCompleter.delegate = self
        searchResultsTableView.isHidden = true
    }
}

extension LocationScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsTableView.isHidden = false
        searchCompleter.queryFragment = searchText
    }
}

extension LocationScreen: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error")
    }
}

extension LocationScreen: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as UITableViewCell
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension LocationScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(searchResults[indexPath.row])
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
            if coordinate?.longitude != nil && coordinate?.latitude != nil {
                UserDefaults.standard.set(coordinate?.longitude, forKey: "longitude")
                UserDefaults.standard.set(coordinate?.latitude, forKey: "latitude")
                self.searchResultsTableView.isHidden = true
                //self.searchBar.text =
                //Make searchbar have selected address
            }
            else {
                print("Error")
            }
        }
    }
}
