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
        //Add website
        let myURL = URL(string:"https://example.com")
        let myRequest = URLRequest(url: myURL!)
        TermsWebView.load(myRequest)
    }
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
        TermsWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        TermsWebView.uiDelegate = self
       view = TermsWebView
    }

}

