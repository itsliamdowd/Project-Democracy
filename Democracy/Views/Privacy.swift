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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to privacy screen")
        let myURL = URL(string:"https://blue-app-group.github.io/DemocracyPrivacyPolicy/")
        let myRequest = URLRequest(url: myURL!)
        PrivacyWebView.load(myRequest)
    }
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
        PrivacyWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        PrivacyWebView.uiDelegate = self
       view = PrivacyWebView
    }

}

