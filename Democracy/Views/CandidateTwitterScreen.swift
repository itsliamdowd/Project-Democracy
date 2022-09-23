//
//  CandidateTwitterScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/4/22.
//

import UIKit
import WebKit

class CandidateTwitterScreen: UIViewController, WKUIDelegate {
    
    @IBOutlet var twitterWebView: WKWebView!
    var candidate: BallotpediaElection.Candidate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to candidate social screen")
        guard let candidate = candidate else {
            return
        }
        //var candidateWebsite = UserDefaults.standard.string(forKey: "candidateSocial")
        if let myURL = candidate.twitterUrl {
            let myRequest = URLRequest(url: myURL)
            twitterWebView.load(myRequest)
        }

    }

}

