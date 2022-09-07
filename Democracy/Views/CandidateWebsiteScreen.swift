//
//  CandidateWebsiteScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/4/22.
//

import UIKit
import WebKit

class CandidateWebsiteScreen: UIViewController, WKUIDelegate {
    
    @IBOutlet var candidateWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to candidate website screen")
        //var candidateWebsite = UserDefaults.standard.string(forKey: "candidateWebsite")
        let myURL = URL(string:"https://www.example.com")
        let myRequest = URLRequest(url: myURL!)
        candidateWebView.load(myRequest)
    }
    
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
        candidateWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        candidateWebView.uiDelegate = self
       view = candidateWebView
    }

}

