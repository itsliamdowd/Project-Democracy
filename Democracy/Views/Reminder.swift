//
//  Reminder.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Reminder: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var ReminderWebView: WKWebView!
    
    //Allows the user to get a reminder to vote
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to reminder screen")
        //Loads the vote.org website in the webView
        let remindURL = URL(string: "https://www.vote.org/election-reminders/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: remindURL)
        let remindRequest = URLRequest(url: translatedURL)
        ReminderWebView.load(remindRequest)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
