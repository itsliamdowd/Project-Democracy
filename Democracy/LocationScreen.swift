//
//  LocationScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit

class LocationScreen: UIViewController {
    
    @IBOutlet var continueButton: UIButton!
    @IBOutlet var streetInput: UITextField!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func currentLocationButton(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreen")
            self.present(vc, animated: true)
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

}
