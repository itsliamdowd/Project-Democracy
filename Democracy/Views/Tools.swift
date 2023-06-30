//
//  Tools.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Tools: UIViewController {
    
    @IBOutlet weak var electionHelp: UILabel!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var reminder: UIButton!
    @IBOutlet weak var polling: UIButton!
    @IBOutlet weak var bottomCaption: UILabel!

    
    @IBAction func registerButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("registerToVote", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func verifyButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("checkIfRegistered", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func reminderButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("electionReminders", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }
    
    @IBAction func pollingButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UserDefaults.standard.set("pollingStations", forKey: "webViewResource")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "CombinedWebView") as? CombinedWebView {
                self.present(vc, animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to tools screen")
        register.layer.cornerRadius = 15
        verify.layer.cornerRadius = 15
        reminder.layer.cornerRadius = 15
        polling.layer.cornerRadius = 15
        TranslateManager.shared.addViews(views: [electionHelp, register, verify, reminder, polling, bottomCaption])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }
}
