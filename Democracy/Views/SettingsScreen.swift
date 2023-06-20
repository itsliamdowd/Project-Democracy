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
    @IBOutlet var source: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet weak var language: UIButton!
    @IBOutlet var appVersion: UILabel!

 // @Storage(key: "AllLanguages", defaultValue: [])
    var allLanguages = [SwiftGoogleTranslate.Language]()

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
        fetchLanguageList {
            self.updateLanguageSettings(selection: self.savedLanguage)
        }
    }

    var savedLanguage: SwiftGoogleTranslate.Language? {
        guard let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage")
        else {
            return nil
        }
        return allLanguages.first(where: {$0.language == savedLanguage})
    }

    @IBAction func openLanguageView(_ sender: UIButton) {
        let swiftUIView = LanguageSelectionView(allLanguages: allLanguages,
                                                selectedLanguage: savedLanguage,
                                                completion: updateLanguageSettings)
            let hostingController = UIHostingController(rootView: swiftUIView)
            present(hostingController, animated: true, completion: nil)
    }

    func updateLanguageSettings(selection: SwiftGoogleTranslate.Language?) {
        var selectedLanguage: String
        if let selected = selection {
            selectedLanguage = selected.language
        }
        else {
            selectedLanguage = "en"
        }
        SwiftGoogleTranslate.shared.translate(screenTitle.text!,
                                              selectedLanguage,
                                              "")
        {[weak self] result, error in
            guard let translatedText = result
            else {
                print(error ?? "Error occured while translating")
                return
            }
            DispatchQueue.main.async {
                self?.screenTitle.text = translatedText
            }
        }
    }

    func fetchLanguageList(completion: @escaping () -> Void) {
        SwiftGoogleTranslate.shared.languages {[weak self] languages, error in
            guard error == nil, let languages = languages
            else {
                print(error!)
                return
            }
            self?.allLanguages = languages
            
            completion()
        }
    }

}

extension SwiftGoogleTranslate.Language: Hashable, Identifiable {
    public var id: Int {
        language.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(language)
        hasher.combine(name)
    }

    public static func == (lhs: SwiftGoogleTranslate.Language, rhs: SwiftGoogleTranslate.Language) -> Bool {
        return lhs.language == rhs.language && lhs.name == rhs.name
    }
}

struct LanguageSelectionView: View {
    @State var allLanguages: [SwiftGoogleTranslate.Language]
    @State var selectedLanguage: SwiftGoogleTranslate.Language?
    var completion: (SwiftGoogleTranslate.Language?) -> Void

    var body: some View {
        NavigationView {
            Picker("Display Language", selection: $selectedLanguage) {
                Text("English (Default)").tag(Optional<String>(nil))
                ForEach(allLanguages) {language in
                    Text(language.name).tag(Optional(language))
                }
            }
            .pickerStyle(.wheel)
            .navigationTitle("Display Language")
        }
        .onDisappear {
            if let selected = selectedLanguage {
                UserDefaults.standard.setValue(selected.language, forKey: "AppLanguage")
            }
            completion(selectedLanguage)
        }
    }
}
