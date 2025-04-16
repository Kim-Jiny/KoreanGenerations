//
//  KoreanGenerationsApp.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import SwiftUI

@main
struct KoreanGenerationsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
