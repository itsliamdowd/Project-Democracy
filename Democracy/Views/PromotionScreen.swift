//
//  PromotionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit

class PromotionScreen: UIViewController {
    
    @IBOutlet var nextButton: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to promotion screen")
        var existingIndex = UserDefaults.standard.integer(forKey: "index")
        existingIndex = existingIndex + 1
        UserDefaults.standard.set(existingIndex, forKey: "index")
        nextButton.layer.cornerRadius = 20
        TranslateManager.shared.addViews(views: [nextButton, descriptionLabel, titleLabel])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }
}
