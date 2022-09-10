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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to contact screen")
        let myURL = URL(string:"https://blue-app-group.github.io/DemocracyContactForm/")
        let myRequest = URLRequest(url: myURL!)
        ContactWebView.load(myRequest)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

