//
//  DashboardView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import MapKit

struct DashboardView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                DashboardHeaderView(user: $tD.currentUser, showingMap: .constant(false))
                VStack(alignment: .leading) {
                    Text("Nearby Activities")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($tD.activities) { $activity in
                                ActivityListItem(activity: $activity)
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                    }
                    Text("Your Next Activity")
                        .modifier(SectionHeader())
                    NextActivityView(activity: $tD.activities[0])
                    Text("Scheduled Activities")
                        .modifier(SectionHeader())
                    ForEach($tD.activities) { $activity in
                        ActivityListItem(activity: $activity)
                            .padding([.leading, .trailing])
                    }
                    .padding(.bottom)
                }
            }
        }
        .background(Color("LightBlue"))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
