//
//  RepresentativeTwitterScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 11/1/22.
//

import UIKit
import WebKit

class RepresentativeTwitterScreen: UIViewController, WKUIDelegate {
    
    @IBOutlet var twitterWebView: WKWebView!
    var representative: Current.Representative
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to representative social screen")
        //Loads the website in the webView
        if representative.twitterUrl != nil && representative.twitterUrl != "" {
            var URLForRequest = "https://twitter.com/" + representative.twitterUrl!
            
            print(URLForRequest)
            //var candidateURL = candidate.facebookUrl
            if let encodedString = URLForRequest.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: URLForRequest) {
                let viewSocialMedia = URLRequest(url: url)
                twitterWebView.load(viewSocialMedia)
            }
        }
        else if representative.facebookUrl != nil {
            let viewSocialMedia = URLRequest(url: representative.facebookUrl!)
            twitterWebView.load(viewSocialMedia)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
