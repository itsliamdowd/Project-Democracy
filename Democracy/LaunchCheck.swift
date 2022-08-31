//
//  LaunchCheck.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit

class LaunchCheck: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to launch check")
        var loggedIn = UserDefaults.standard.string(forKey: "loggedIn")
        switch loggedIn {
            case "true":
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(vc, animated: true)
                }
            case "false" :
               DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PromotionScreen")
                    self.present(vc, animated: true)
                }
            case nil:
                DispatchQueue.main.async {
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "PromotionScreen")
                     self.present(vc, animated: true)
                }
            default:
                 DispatchQueue.main.async {
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "PromotionScreen")
                     self.present(vc, animated: true)
                 }
        }
    }

}
