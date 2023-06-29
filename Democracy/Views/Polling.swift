//
//  Polling.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Polling: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var PollingWebView: WKWebView!

    //Allows the user to check local polling stations
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to polling screen")
        //Loads the vote.org website in the webView
        configureWebView()
    }

    func configureWebView() {
        let pollingURL = URL(string: "https://www.vote.org/polling-place-locator/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: pollingURL)
        let pollingRequest = URLRequest(url: pollingURL)
        PollingWebView.load(pollingRequest)
    }

    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
