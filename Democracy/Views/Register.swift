//
//  Register.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Register: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var RegisterWebView: WKWebView!
    
    //Allows the user to register to vote
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to register screen")
        //Loads the vote.org website in the webView
        let registerURL = URL(string: "https://vote.org/register-to-vote/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: registerURL)
        let registerRequest = URLRequest(url: translatedURL)
        RegisterWebView.load(registerRequest)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
