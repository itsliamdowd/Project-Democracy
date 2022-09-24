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
        //Makes candidate usable by the program
        guard let candidate = candidate else {
            return
        }
        //Loads the website in the webView
        if let myURL = candidate.twitterUrl {
            candidateURL = candidate.twitterUrl
            //candidateURL = candidate.facebookUrl
            let viewSocialMedia = URLRequest(url: candidateURL)
            twitterWebView.load(viewSocialMedia)
        }
    }
}
