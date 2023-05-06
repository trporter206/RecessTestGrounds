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
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "globe")
                                .font(.system(size: 24, weight: .bold))
                                .padding([.horizontal, .top])
                            Text("Dashboard").font(.footnote)
                        }
                    }
                    .accentColor(selectedTab == 0 ? .orange : .white)
                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "figure.basketball")
                                .font(.system(size: 24, weight: .bold))
                                .padding([.horizontal, .top])
                            Text("Activities").font(.footnote)
                        }
                    }
                    .accentColor(selectedTab == 1 ? .orange : .white)
                    Spacer()
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 24, weight: .bold))
                                .padding([.horizontal, .top])
                            Text("Profile").font(.footnote)
                        }
                    }
                    .accentColor(selectedTab == 2 ? .orange : .white)
                    Spacer()
                    Button(action: {
                        selectedTab = 3
                    }) {
                        VStack {
                            Image(systemName: "questionmark")
                                .font(.system(size: 24, weight: .bold))
                                .padding([.horizontal, .top])
                            Text("Help").font(.footnote)
                        }
                    }
                    .accentColor(selectedTab == 3 ? .orange : .white)
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

//struct NavBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavBarView()
//            .environmentObject(LocationManager())
//            .environmentObject(TestData())
//    }
//}
