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
    
    @IBAction func sourceCodeButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("sourceCode", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
    
    @IBAction func feedback(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("contact", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("privacyPolicy", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
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

