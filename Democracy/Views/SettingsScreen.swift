//
//  SettingsScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit
import SwiftUI
import Foundation

class SettingsScreen: UIViewController {
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet var privacy: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet var source: UIButton!
    @IBOutlet weak var language: UIButton!
    @IBOutlet var appVersion: UILabel!
    @IBOutlet weak var developerCaption: UILabel!
    @IBOutlet weak var copyrightCaption: UILabel!

    
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
        language.layer.cornerRadius = 15
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
           self.appVersion.text = "App version " + version
       }
        TranslateManager.shared.addViews(views: [privacy, source, feedback, language, screenTitle, appVersion, developerCaption, copyrightCaption])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }

    @IBAction func openLanguageView(_ sender: UIButton) {
        let swiftUIView = LanguageSelectionView {
            TranslateManager.shared.updateTranslatedLabels()
        }

        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
}
