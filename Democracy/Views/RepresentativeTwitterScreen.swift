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
    var representative: Current.Representative?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to representative social screen")
        guard let representative = representative else {
            return
        }
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
            var link = "https://facebook.com/" + representative.facebookUrl!
            if let encodedString = link.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: link) {
                let viewSocialMedia = URLRequest(url: url)
                twitterWebView.load(viewSocialMedia)
            }
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
