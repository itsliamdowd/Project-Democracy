//
//  SettingsScreen.swift
//  Democracy
//
//  Created by Liam Dowd on 9/6/22.
//

import UIKit
import WebKit
import SwiftUI
import SwiftGoogleTranslate
import Foundation

class SettingsScreen: UIViewController {
    
    @IBOutlet weak var screenTitle: UILabel!

    @IBOutlet var privacy: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet var source: UIButton!
    @IBOutlet weak var language: UIButton!
    @IBOutlet var appVersion: UILabel!
    @IBOutlet weak var developerCaption: UILabel!
    @IBOutlet weak var copyrightCaption: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Made it to settings screen")
        privacy.layer.cornerRadius = 15
        source.layer.cornerRadius = 15
        feedback.layer.cornerRadius = 15
        language.layer.cornerRadius = 15
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
           self.appVersion.text = "App version " + version
       }
        TranslateManager.shared.addViews(views: [privacy, source, feedback, language, screenTitle, appVersion, developerCaption, copyrightCaption])

    }

    override func viewWillAppear(_ animated: Bool) {
        TranslateManager.shared.updateTranslatedLabels()
    }

    @IBAction func openLanguageView(_ sender: UIButton) {
        let swiftUIView = LanguageSelectionView {
            TranslateManager.shared.updateTranslatedLabels()
        }

        let hostingController = UIHostingController(rootView: swiftUIView)
        present(hostingController, animated: true, completion: nil)
    }
}

struct LanguageSelectionView: View {
    init(completion: @escaping () -> Void) {
        self.selectedLanguage = SwiftGoogleTranslate.shared.savedLanguage
        self.completion = completion
    }

    //@State var allLanguages: [SwiftGoogleTranslate.Language]
    @State var selectedLanguage = SwiftGoogleTranslate.shared.savedLanguage
    var completion: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Display Language", selection: $selectedLanguage) {
                    let allLanguages = SwiftGoogleTranslate.shared.allLanguages
                    ForEach(allLanguages) {language in
                        Text(language.name).tag(language)
                    }
                }
                .pickerStyle(.wheel)

                Button("English (Default)".translated()) {
                    withAnimation {
                        selectedLanguage = .english
                        TranslateManager.shared.revertToOriginal()
                    }
                }
                .padding()
            }
            .navigationTitle("Display Language".translated())
        }
        .onDisappear {
            if selectedLanguage != SwiftGoogleTranslate.shared.savedLanguage {
                UserDefaults.standard.setValue(selectedLanguage.language, forKey: "AppLanguage")
                SwiftGoogleTranslate.shared.translationCache = [:]
                completion()
            }

        }
    }
}
