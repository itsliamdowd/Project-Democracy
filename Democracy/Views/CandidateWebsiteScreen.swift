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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to candidate website screen")
        guard let candidate = candidate else {
            return
        }
        //var candidateWebsite = UserDefaults.standard.string(forKey: "candidateWebsite")
        if let myURL = candidate.websiteUrl {
            let myRequest = URLRequest(url: myURL)
            candidateWebView.load(myRequest)
        }

    }

}

