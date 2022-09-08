//
//  TalkScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit

class TalkScreen: UIViewController {
    
    @IBOutlet var districtText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to talk screen")
        if UserDefaults.standard.string(forKey: "electionDistrict") != nil {
            self.districtText.text = UserDefaults.standard.string(forKey: "electionDistrict")
        }
        else {
            print("Error")
        }
    }

}
