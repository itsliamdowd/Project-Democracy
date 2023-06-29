//
//  Check.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Check: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var CheckWebView: WKWebView!
    
    //Allows the user to check if they are registered to vote
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to check screen")
        //Loads the vote.org website in the webView
        let checkURL = URL(string: "https://www.vote.org/am-i-registered-to-vote/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: checkURL)
        let checkRequest = URLRequest(url: translatedURL)
        CheckWebView.load(checkRequest)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
