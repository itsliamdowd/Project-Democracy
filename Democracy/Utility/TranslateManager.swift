//
//  TranslateManager.swift
//  Democracy
//
//  Created by Jevon Mao on 6/21/23.
//

import Foundation
import UIKit

struct TranslateManager {
    static var shared = TranslateManager()

    var originalTexts = [UIView: [String?]]()

    mutating func addViews(views: [UIView]) {
        for view in views {
            originalTexts[view] = view.getTextLabel()
        }
    }
    
    func updateTranslatedLabels() {
        //revertToOriginal()
        if !SwiftGoogleTranslate.shared.isDefaultLanguage {
            for (view, originalLabel) in originalTexts {
                view.setTextLabel {_ in
                    originalLabel.compactMap {title in
                        return title?.translated()
                    }
                }
            }
        }
        else {
            revertToOriginal()
        }
    }

    func revertToOriginal() {
        for (view, _) in originalTexts {
            view.setTextLabel {_ in
                let original = originalTexts[view]?.compactMap {title in
                    return title
                }

                return original ?? []
            }
        }
    }
}

extension UIView {
    func getTextLabel() -> [String?] {
        if let label = self as? UILabel {
            return [label.text]
        }

        if let button = self as? UIButton {
            return [button.titleLabel?.text]
        }

        if let textField = self as? UITextField {
            return [textField.text]
        }

        if let textView = self as? UITextView {
            return [textView.text]
        }

        if let segmentedControl = self as? UISegmentedControl {
            var segmentLabels = [String?]()
            for segment in 0..<segmentedControl.numberOfSegments {
                segmentLabels.append(segmentedControl.titleForSegment(at: segment))
            }
            return segmentLabels
        }

        for _ in self.subviews {
            return getTextLabel()
        }

        return []
    }

    func setTextLabel(transform: ([String]) -> [String]) {
        let labels = self.getTextLabel().compactMap {$0}
        let transformedText = transform(labels).first

        switch self {
        case let label as UILabel:
            label.text = transformedText
            label.setAutoShrink()

        case let button as UIButton:
            button.setTitle(transformedText, for: .normal)
            button.titleLabel?.setAutoShrink()

        case let textField as UITextField:
            textField.placeholder = transformedText

        case let textView as UITextView:
            textView.text = transformedText

        case let segmentedControl as UISegmentedControl:
            let labels = self.getTextLabel().compactMap {$0}
            let transformed = transform(labels)
            for (index, title) in transformed.enumerated() {
                segmentedControl.setTitle(title, forSegmentAt: index)
            }
        case let tableView as UITableView:
            // Assume translation handled in respective delegates
            tableView.reloadData()

        default:
            break
        }
        }
}

extension UILabel {
    func setAutoShrink() {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3
    }
}
