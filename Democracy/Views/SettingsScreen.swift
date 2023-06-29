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
                Label("Powered by **Google** Translate",
                      systemImage: "info.square.fill")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                Spacer()
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
                Spacer()
                Text("THIS SERVICE MAY CONTAIN TRANSLATIONS POWERED BY GOOGLE. GOOGLE DISCLAIMS ALL WARRANTIES RELATED TO THE TRANSLATIONS, EXPRESS OR IMPLIED, INCLUDING ANY WARRANTIES OF ACCURACY, RELIABILITY, AND ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\nThe official text is the English version of the app. Any discrepancies or differences created in the translation are not binding and have no legal effect for compliance or enforcement purposes. If any questions arise related to the accuracy of the information contained in the translated website, refer to the English version of the website which is the official version.")
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
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
