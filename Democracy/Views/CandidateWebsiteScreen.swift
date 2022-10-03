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
    var candidate: BallotpediaElection.Candidate?
    
    //Shows the candidate's website in a webView
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to candidate website screen")
        //Makes candidate usable by the program
        guard let candidate = candidate else {
            return
        }
        //Loads the website in the webView
        if let myURL = candidate.websiteUrl {
            var URLtoHTTPS = URLComponents(url: candidate.websiteUrl!, resolvingAgainstBaseURL: false)!
            URLtoHTTPS.scheme = "https"
            let https = URLtoHTTPS.url!
            let myRequest = URLRequest(url: https)
            candidateWebView.load(myRequest)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
