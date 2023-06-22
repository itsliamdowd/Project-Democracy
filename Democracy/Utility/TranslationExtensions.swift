//
//  TranslationExtensions.swift.swift
//  Democracy
//
//  Created by Jevon Mao on 6/20/23.
//

import Foundation
import UIKit

extension String {
    func translated() -> Self {
        var copy = self
        copy.translate()
        return copy
    }

    mutating func translate() {
        if let result = SwiftGoogleTranslate.shared.translationCache[self] {
            self = result
            return
        }
        if SwiftGoogleTranslate.shared.savedLanguage == .english {
            return
        }

        let semaphore = DispatchSemaphore(value: 0)
        var translatedText: String?

        SwiftGoogleTranslate.shared.translate(self,
                                              SwiftGoogleTranslate.shared.savedLanguage.language,
                                              "") { result, error in
                defer {
                    semaphore.signal()
                }

                guard let result = result else {
                    print(error ?? "Error occurred while translating")
                    return
                }
                translatedText = result
            }

            semaphore.wait()
            guard let translatedText = translatedText
            else {
                return
            }
        SwiftGoogleTranslate.shared.translationCache[self] = translatedText
        self = translatedText
    }
}
