//
//  RepresentativeVideoScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 11/2/22.
//

import UIKit
import WebKit

class RepresentativeVideoScreen: UIViewController, WKUIDelegate {
    
    @IBOutlet var videoWebView: WKWebView!
    var representative: Current.Representative?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to representative social screen")
        guard let representative = representative else {
            return
        }
        //Loads the website in the webView
        if representative.youtubeUrl != nil && representative.youtubeUrl != "" {
            var URLForRequest = "https://youtube.com/user/" + representative.youtubeUrl!
            print(URLForRequest)
            if let encodedString = URLForRequest.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: URLForRequest) {
                let viewSocialMedia = URLRequest(url: url)
                videoWebView.load(viewSocialMedia)
            }
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
