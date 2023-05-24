//
//  RecessTestGroundsApp.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct RecessTestGroundsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
