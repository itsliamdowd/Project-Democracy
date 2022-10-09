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
    
    //Defines variables for search completion and for accessing location
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Moves onto HomeScreen only if the longitude and latitude UserDefaults are not empty
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
    
    //Gets current location of the user if they don't want to type in an address
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
    
    //Gets location value, saves it to UserDefaults, and then presents HomeScreen if the values saved successfully
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        UserDefaults.standard.set(locValue.longitude, forKey: "longitude")
        UserDefaults.standard.set(locValue.latitude, forKey: "latitude")
        if UserDefaults.standard.string(forKey: "longitude") == nil {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "latitude") == nil {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "longitude") == "" {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "latitude") == "" {
            print("Error")
        }
        else if UserDefaults.standard.string(forKey: "longitude") != nil && UserDefaults.standard.string(forKey: "latitude") != nil && UserDefaults.standard.string(forKey: "longitude") != "" && UserDefaults.standard.string(forKey: "latitude") != "" {
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
    
    //Hides search completer
    override func viewDidLoad() {
        super.viewDidLoad()
        var existingIndex = UserDefaults.standard.integer(forKey: "index")
        existingIndex = existingIndex + 1
        UserDefaults.standard.set(existingIndex, forKey: "index")
        continueButton.layer.cornerRadius = 20
        searchCompleter.delegate = self
        searchResultsTableView.isHidden = true
    }
}

//Displays search completer when the user taps the search bar
extension LocationScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResultsTableView.isHidden = false
        searchCompleter.queryFragment = searchText
    }
}

//Loads search results for the location the user typed in the search bar and refreshes searchResultsTableView
extension LocationScreen: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error")
    }
}

//Setting up the basic data for UITableView
extension LocationScreen: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

//Handles if a location is selected in the tableView and then closes the tableView, sets the search bar address to the address selected by the user, and sets the coordinates to UserDefaults values
extension LocationScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(searchResults[indexPath.row])
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            var placeMark = response?.mapItems[0].placemark
            print(String(describing: coordinate))
            if coordinate?.longitude != nil && coordinate?.latitude != nil {
                //Sets longitude and latitude
                UserDefaults.standard.set(coordinate?.longitude, forKey: "longitude")
                UserDefaults.standard.set(coordinate?.latitude, forKey: "latitude")
                //Hides search results table
                self.searchResultsTableView.isHidden = true
                //Changes searchbar to display selected address
                var fullAddress = "\(placeMark!.thoroughfare!)\n\(placeMark!.postalCode!) \(placeMark!.locality!)\n\(placeMark!.country!)"
                self.searchBar.text = fullAddress
                print(UserDefaults.standard.string(forKey: "longitude"))
                print(UserDefaults.standard.string(forKey: "latitude"))
            }
            else {
                print("Error")
            }
        }
    }
}
