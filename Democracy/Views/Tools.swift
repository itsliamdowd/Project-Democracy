//
//  Tools.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Tools: UIViewController {
    
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var reminder: UIButton!
    @IBOutlet weak var polling: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to tools screen")
        register.layer.cornerRadius = 15
        verify.layer.cornerRadius = 15
        reminder.layer.cornerRadius = 15
        polling.layer.cornerRadius = 15
    }
}

