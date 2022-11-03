//
//  RepresentativeWebsiteScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 11/1/22.
//

import UIKit
import WebKit

class RepresentativeWebsiteScreen: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var representativeWebView: WKWebView!
    var representative: Current.Representative?
    
    //Shows the candidate's website in a webView
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to representative website screen")
        guard let representative = representative else {
            return
        }
        //Makes candidate usable by the program
        //Loads the website in the webView
        if let myURL = representative.url {
            var URLtoHTTPS = URLComponents(url: representative.url!, resolvingAgainstBaseURL: false)!
            URLtoHTTPS.scheme = "https"
            let https = URLtoHTTPS.url!
            let myRequest = URLRequest(url: https)
            representativeWebView.load(myRequest)
        }
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
