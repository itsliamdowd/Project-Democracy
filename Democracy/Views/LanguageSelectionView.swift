//
//  LanguageSelectionView.swift
//  Democracy
//
//  Created by Jevon Mao on 7/13/23.
//

import Foundation
import SwiftUI

struct LanguageSelectionView: View {
    init(completion: @escaping () -> Void) {
        self.selectedLanguage = SwiftGoogleTranslate.shared.savedLanguage
        self.completion = completion
    }

    //@State var allLanguages: [SwiftGoogleTranslate.Language]
    @State var selectedLanguage = SwiftGoogleTranslate.shared.savedLanguage
    var completion: () -> Void
    
    @State var displayLanguage = "Display Language".translated()
    @State var englishDefault = "English (Default)".translated()
    
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
                    .onChange(of: selectedLanguage) {newValue in
                        if selectedLanguage != SwiftGoogleTranslate.shared.savedLanguage {
                            if (selectedLanguage.language == "en") {
                                UserDefaults.standard.set(selectedLanguage.language, forKey: "appLanguage")
                                SwiftGoogleTranslate.shared.translationCache = [:]
                                backToEnglish()
                            }
                            else {
                                UserDefaults.standard.set(selectedLanguage.language, forKey: "appLanguage")
                                SwiftGoogleTranslate.shared.translationCache = [:]
                                TranslateManager.shared.updateTranslatedLabels()
                                updateLanguage()
                            }
                        }
                    }
                    
                    Button(englishDefault) {
                        withAnimation {
                            selectedLanguage = .english
                            backToEnglish()
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
                .navigationTitle(displayLanguage)
        }
        .onDisappear() {
            completion()
        }
    }
    func updateLanguage() {
        displayLanguage = displayLanguage.translated()
        englishDefault = englishDefault.translated()
    }
    func backToEnglish() {
        TranslateManager.shared.revertToOriginal()
        displayLanguage = "Display Language"
        englishDefault = "English (Default)"
    }
}
