//
//  SettingsScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit

class SettingsScreen: UIViewController {
    
    @IBOutlet var privacy: UIButton!
    @IBOutlet var source: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet var appVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to settings screen")
        privacy.layer.cornerRadius = 15
        source.layer.cornerRadius = 15
        feedback.layer.cornerRadius = 15
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
           self.appVersion.text = "App version " + version
       }
    }

}

