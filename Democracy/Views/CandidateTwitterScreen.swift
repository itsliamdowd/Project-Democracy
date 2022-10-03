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
        if candidate.twitterUrl != nil && candidate.twitterUrl != "" {
            var URLForRequest = "https://twitter.com/" + candidate.twitterUrl!
            
            print(URLForRequest)
            //var candidateURL = candidate.facebookUrl
            if let encodedString = URLForRequest.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: URLForRequest) {
                let viewSocialMedia = URLRequest(url: url)
                twitterWebView.load(viewSocialMedia)
            }
        }
        else if candidate.facebookUrl != nil {
            let viewSocialMedia = URLRequest(url: candidate.facebookUrl!)
            twitterWebView.load(viewSocialMedia)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
