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
        let myURL = URL(string: "https://projectdemocracy.app/legal/")
        let myRequest = URLRequest(url: myURL!)
        PrivacyWebView.load(myRequest)
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

