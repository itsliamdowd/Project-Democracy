//
//  SourceCode.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit

class SourceCode: UIViewController, WKUIDelegate {
    
    @IBOutlet var SourceCodeWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to source code screen")
        let myURL = URL(string: "https://github.com/SkiingIsFun123/Project-Democracy")!
        let translatedURL = SwiftGoogleTranslate.shared.getTranslatedUrl(for: myURL)
        let myRequest = URLRequest(url: translatedURL)
        SourceCodeWebView.load(myRequest)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

