//
//  Terms.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit

class Terms: UIViewController, WKUIDelegate {
    
    @IBOutlet var TermsWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to terms screen")
        let myURL = URL(string: "https://blue-app-group.github.io/DemocracyTermsAndConditions/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: myURL)
        let myRequest = URLRequest(url: translatedURL)
        TermsWebView.load(myRequest)
    }

}

