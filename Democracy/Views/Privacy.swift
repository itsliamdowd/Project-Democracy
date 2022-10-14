//
//  Privacy.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit

class Privacy: UIViewController, WKUIDelegate {
    
    @IBOutlet var PrivacyWebView: WKWebView!
    
    //Loads the privacy policy in a webView
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to privacy screen")
        let privacyURL = URL(string: "https://projectdemocracy.app/privacypolicy/")
        let privacyRequest = URLRequest(url: privacyURL!)
        PrivacyWebView.load(privacyRequest)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
