//
//  PromotionScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 8/30/22.
//

import UIKit
import SwiftUI

class PromotionScreen: UIViewController {
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageSwitch: UIButton!
    
    @IBAction func languageButtonPressed(_ sender: Any) {
        let swiftUIView = LanguageSelectionView {
            TranslateManager.shared.updateTranslatedLabels()
        }

        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to promotion screen")
        //var appLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        //languageSwitch.setTitle(appLanguage, for: .normal)
        var existingIndex = UserDefaults.standard.integer(forKey: "index")
        existingIndex = existingIndex + 1
        UserDefaults.standard.set(existingIndex, forKey: "index")
        nextButton.layer.cornerRadius = 20
        TranslateManager.shared.addViews(views: [nextButton, descriptionLabel, titleLabel, languageSwitch])
    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }
}
