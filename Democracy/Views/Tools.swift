//
//  Tools.swift
//  Democracy
//
//  Created by Liam Dowd on 10/15/22.
//

import UIKit
import WebKit

class Tools: UIViewController {
    
    @IBOutlet weak var electionHelp: UILabel!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var verify: UIButton!
    @IBOutlet weak var reminder: UIButton!
    @IBOutlet weak var polling: UIButton!
    @IBOutlet weak var bottomCaption: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to tools screen")
        register.layer.cornerRadius = 15
        verify.layer.cornerRadius = 15
        reminder.layer.cornerRadius = 15
        polling.layer.cornerRadius = 15
        TranslateManager.shared.addViews(views: [electionHelp, register, verify, reminder, polling, bottomCaption])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }
}
