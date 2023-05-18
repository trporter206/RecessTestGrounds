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
    @State private var selectedTab: Int = 0
    
    var body: some View {
        Group {
            if selectedTab == 0 {
                DashboardView()
                    .environmentObject(lM)
                    .environmentObject(tD)
                    .padding([.bottom], 60)
            } else if selectedTab == 1 {
                ActivityListView()
                    .environmentObject(lM)
                    .environmentObject(tD)
                    .padding([.bottom], 60)
            } else if selectedTab == 2 {
                MyProfileView(user: $tD.currentUser)
                    .padding([.bottom], 60)
            } else if selectedTab == 3 {
                InfoPageView()
                    .padding([.bottom], 60)
            }
        }.overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavButtonView(selectedTab: $selectedTab,
                                  imageString: "globe",
                                  label: "Dashboard",
                                  index: 0)
                    Spacer()
                    NavButtonView(selectedTab: $selectedTab,
                                  imageString: "figure.basketball",
                                  label: "Activities",
                                  index: 1)
                    Spacer()
                    NavButtonView(selectedTab: $selectedTab,
                                  imageString: "person.circle",
                                  label: "Profile",
                                  index: 2)
                    Spacer()
                    NavButtonView(selectedTab: $selectedTab,
                                  imageString: "questionmark",
                                  label: "Help",
                                  index: 3)
                    Spacer()
                }
                .background(Color("TextBlue"))
            }
        )
        .onAppear {
            lM.checkIfLocationServicesEnabled()
        }
    }
}

struct NavButtonView: View {
    @Binding var selectedTab: Int
    var imageString: String
    var label: String
    var index: Int
    
    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack {
                Image(systemName: imageString)
                    .font(.system(size: 24, weight: .bold))
                    .padding([.horizontal, .top])
                Text(label).font(.footnote)
            }
        }
        .accentColor(selectedTab == index ? .orange : .white)
    }
}

//struct NavBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavBarView()
//            .environmentObject(LocationManager())
//            .environmentObject(TestData())
//    }
//}
