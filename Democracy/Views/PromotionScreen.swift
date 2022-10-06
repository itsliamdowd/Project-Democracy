//
//  PromotionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit

class PromotionScreen: UIViewController {
    
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to promotion screen")
        nextButton.layer.cornerRadius = 20
    }
}
