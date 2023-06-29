//
//  Contact.swift
//  Democracy
//
//  Created by Liam Dowd on 9/8/22.
//

import UIKit
import WebKit

class Contact: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var ContactWebView: WKWebView!
    
    //Allows the user to contact the developers using the contact website
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to contact screen")
        //Loads the contact website in the webView
        let contactURL = URL(string: "https://projectdemocracy.app/contact/")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: contactURL)
        let contactRequest = URLRequest(url: translatedURL)
        ContactWebView.load(contactRequest)
    }
    
    //Dismiss viewcontroller
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
