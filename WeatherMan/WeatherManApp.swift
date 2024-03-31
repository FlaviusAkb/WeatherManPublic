//
//  WeatherManApp.swift
//  WeatherMan
//
//  Created by Flavius Lucian Ilie on 08.12.2023.
//
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

import SwiftUI

@main
struct WeatherManApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}
