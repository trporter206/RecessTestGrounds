//
//  ContentView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @StateObject var tD = TestData()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some View {
        NavigationStack {
            if tD.loggedIn == false {
                LoginView()
                    .environmentObject(tD)
            } else {
                NavBarView()
                    .environmentObject(tD)
                    .environmentObject(locationManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
