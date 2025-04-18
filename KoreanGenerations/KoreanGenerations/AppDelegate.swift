//
//  AppDelegate.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    MobileAds.shared.start(completionHandler: nil)

    return true
  }
}
