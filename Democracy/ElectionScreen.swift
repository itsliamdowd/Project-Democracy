//
//  ElectionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

class ElectionScreen: UIViewController {
    
    @IBOutlet var electionName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to election screen")
        if UserDefaults.standard.string(forKey: "electionName") != nil {
            self.electionName.text = UserDefaults.standard.string(forKey: "electionName")
        }
        else {
            print("Error")
        }
    }

}
