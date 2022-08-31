//
//  CanidateScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/31/22.
//

import UIKit

class CanidateScreen: UIViewController {
    
    @IBOutlet var canidateName: UILabel!
    @IBOutlet var canidateParty: UIButton!
    @IBOutlet var canidateOccupation: UILabel!
    @IBOutlet var canidateImage: UIImageView!
    @IBOutlet var swipeScreen: UIView!
    @IBOutlet var textScreen: UIView!
    @IBOutlet var nextView: UIView!
    @IBOutlet var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to canidate screen")
        var party = "Republican"
        canidateParty.layer.cornerRadius = 15
        swipeScreen.layer.cornerRadius = 15
        nextView.layer.cornerRadius = 15
        backView.layer.cornerRadius = 15
        switch party {
            case "Republican Party":
                print("Republican")
                canidateParty.backgroundColor = UIColor.red
                //canidateParty.text = "Republican"
            case "Democratic Party":
                print("Democrat")
                canidateParty.backgroundColor = UIColor.blue
                //canidateParty.text = "Democrat"
            case "Libertarian Party":
                print("Libertarian")
                canidateParty.backgroundColor = UIColor.yellow
                //canidateParty.text = "Libertarian"
            case "Green Party":
                print("Green")
                canidateParty.backgroundColor = UIColor.green
                //canidateParty.text = "Green"
            default:
                print("Other")
                canidateParty.backgroundColor = UIColor.gray
                //canidateParty.text = "Green"
        }
        if UserDefaults.standard.string(forKey: "canidateName") != nil {
            print(self.canidateName.text)
            print(UserDefaults.standard.string(forKey: "canidateName"))
            self.canidateName.text = UserDefaults.standard.string(forKey: "canidateName")
        }
        else {
            print("Error")
        }
        

    }

}
