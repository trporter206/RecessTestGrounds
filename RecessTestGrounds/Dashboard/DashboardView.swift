//
//  DashboardView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                MyProfileHeader(user: $tD.currentUser)
                VStack() {
                    Text("Nearby Activities")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($tD.activities) { $activity in
                                ActivityListItem(activity: $activity)
                                    .environmentObject(lM)
                                    .environmentObject(tD)
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                    }
                    Text("Your Next Activity")
                        .modifier(SectionHeader())
                    if tD.activities.count > 0 {
                        NextActivityView(activity: $tD.activities[0])
                            .environmentObject(lM)
                            .environmentObject(tD)
                    }
                    Text("Scheduled Activities")
                        .modifier(SectionHeader())
                    ForEach($tD.activities) { $activity in
                        ActivityListItem(activity: $activity)
                            .environmentObject(lM)
                            .environmentObject(tD)
                            .padding([.leading, .trailing])
                    }
                    .padding(.bottom)
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
