//
//  AppDelegate.swift
//  Democracy
//
//  Created by Liam Dowd on 8/24/22.
//

import UIKit
import SwiftGoogleTranslate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let filePath = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
            fatalError("Couldn't find file 'Secret.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let key = plist?.object(forKey: "translate_API_key") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Secret.plist'.")
        }
        SwiftGoogleTranslate.shared.start(with: key)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

