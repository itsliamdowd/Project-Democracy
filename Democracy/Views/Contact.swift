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
        let myURL = URL(string:"https://example.com")
        let myRequest = URLRequest(url: myURL!)
        ContactWebView.load(myRequest)
    }
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
        ContactWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        ContactWebView.uiDelegate = self
       view = ContactWebView
    }

}

