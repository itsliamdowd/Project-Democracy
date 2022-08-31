//
//  LocationScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit
import CoreLocation

class LocationScreen: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var streetInput: UITextField!
    
    let locationManager = CLLocationManager()
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if streetInput.text == nil {
            print("Error")
        }
        else if streetInput.text == "" {
            print("Error")
        }
        else if streetInput.text != "" && streetInput.text != nil {
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
    
    @IBAction func currentLocationButton(_ sender: Any) {
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
        UserDefaults.standard.set(locValue.latitude, forKey: "latitude")
        UserDefaults.standard.set(locValue.longitude, forKey: "longitude")
        if UserDefaults.standard.string(forKey: "longitude") != nil && UserDefaults.standard.string(forKey: "latitude") != nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
                self.present(vc, animated: true)
            }
        }
        else {
            print("Pass")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to location screen")
        continueButton.layer.cornerRadius = 20
        streetInput.layer.cornerRadius = 10
        streetInput.layer.borderWidth = 1
        streetInput.layer.borderColor = UIColor.black.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        streetInput.becomeFirstResponder()
    }

}
