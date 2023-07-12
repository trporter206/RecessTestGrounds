//
//  ContentView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: NotificationsController
    @StateObject var lM = LocationManager()
    @StateObject var tD = TestData(skipFetching: true) //MAKE SURE IS FALSE FOR PRODUCTION
    
    init() {
//        must manually enter initial value inside function when using
//        FirestoreService.shared.updateDocs(collection: "", fieldName: "") {error in
//            if let error = error {
//                print("error updating documents: \(error)")
//            } else {
//                print("successfully updated documents")
//            }
//        }
    }
    
    
    var body: some View {
        NavigationStack {
            if tD.loggedIn == false {
                LoginView()
                    .environmentObject(tD)
                    .environmentObject(lM)
            } else {
                NavBarView()
                    .environmentObject(tD)
                    .environmentObject(lM)
//                    .environmentObject(appDelegate)
            }
        }
        .padding(.bottom)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
