//
//  AppDelegate.swift
//  SeSAC_Friends
//
//  Created by 박연배 on 2022/01/18.
//

import UIKit
import Firebase
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserInfo.fcmToken = token
            }
        }
        
        // For Back button customization, setup the custom image for UINavigationBar inside CustomBackButtonNavController.
        let backButtonBackgroundImage = UIImage(asset: Asset.arrow)
        let barAppearance =
            UINavigationBar.appearance()
        barAppearance.backIndicatorImage = backButtonBackgroundImage
        barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        barAppearance.tintColor = .defaultBlack
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .highlighted)
        
        NMFAuthManager.shared().clientId = ""
        
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

