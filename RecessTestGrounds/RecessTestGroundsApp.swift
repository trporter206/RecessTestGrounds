//
//  RecessTestGroundsApp.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import UserNotifications

@main
struct RecessTestGroundsApp: App {
    
    @UIApplicationDelegateAdaptor(NotificationsController.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
        }
    }
}
