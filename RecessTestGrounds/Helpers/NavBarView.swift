//
//  NavBarView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-31.
//

import SwiftUI

struct NavBarView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
//        VStack {
            TabView {
                DashboardView()
                    .tabItem { Label ("Dashboard", systemImage: "globe")}
                ClubListView()
                    .tabItem { Label ("Clubs", systemImage: "person.3.fill")}
                ActivityListView()
                    .tabItem { Label ("Games", systemImage: "figure.basketball")}
                MyProfileView(user: $tD.currentUser)
                    .tabItem { Label ("Profile", systemImage: "person.circle")}
            }
            .onAppear {
                lM.checkIfLocationServicesEnabled()
            }
//        }
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
