//
//  CombinedWebView.swift
//  Democracy
//
//  Created by Liam Dowd on 6/23/23.
//

import UIKit
import WebKit

class CombinedWebView: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var resource = UserDefaults.standard.string(forKey: "webViewResource")
    
    //Setting webview URL and accessing it
    override func viewDidLoad() {
        super.viewDidLoad()
        var resourceURL = URL(string: "")
        if (resource == "sourceCode") {
            resourceURL = URL(string: "https://github.com/itsliamdowd/Project-Democracy")
        }
        else if (resource == "privacyPolicy") {
            resourceURL = URL(string: "https://projectdemocracy.app/privacypolicy/")
        }
        else if (resource == "registerToVote") {
            resourceURL = URL(string: "https://vote.org/register-to-vote/")
        }
        else if (resource == "contact") {
            resourceURL = URL(string: "https://projectdemocracy.app/contact/")
        }
        else if (resource == "checkIfRegistered") {
            resourceURL = URL(string: "https://www.vote.org/am-i-registered-to-vote/")
        }
        else if (resource == "electionReminders") {
            resourceURL = URL(string: "https://www.vote.org/election-reminders/")
        }
        else if (resource == "pollingStations"){
            resourceURL = URL(string: "https://www.vote.org/polling-place-locator/")
        }
        let translatedUrl = SwiftGoogleTranslate.shared.getTranslatedUrl(for: resourceURL!)
        let request = URLRequest(url: translatedUrl)
        webView.load(request)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
