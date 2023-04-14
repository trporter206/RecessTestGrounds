//
//  DashboardView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import CoreLocation

struct DashboardView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                MyProfileHeader(user: $tD.currentUser)
                VStack() {
                    //players do not contain currentuserID
                    Text("Nearby Activities")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($tD.activities) { $activity in
                                if !$activity.wrappedValue.players.contains(tD.currentUser.id) {
                                    ActivityListItem(activity: $activity)
                                        .environmentObject(lM)
                                        .environmentObject(tD)
                                        .padding(.trailing)
                                }
                            }
                        }
                        .padding()
                    }
                    //index 0 for activities containing currentuser ID, sorted by date
                    Text("Your Next Activity")
                        .modifier(SectionHeader())
                    if scheduled().count > 0 {
                        NextActivityView(activity: scheduled()[0])
                            .environmentObject(lM)
                            .environmentObject(tD)
                    }
                    Text("Scheduled Activities")
                        .modifier(SectionHeader())
                    ForEach(scheduled().dropFirst()) { $activity in
                        if $activity.wrappedValue.players.contains(tD.currentUser.id) {
                            ActivityListItem(activity: $activity)
                                .environmentObject(lM)
                                .environmentObject(tD)
                                .padding([.leading, .trailing])
                        }
                    }
                    .padding(.bottom)
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

extension DashboardView {
    func scheduled() -> [Binding<Activity>] {
        var results: [Binding<Activity>] = []
        for activity in $tD.activities {
            if activity.wrappedValue.players.contains(tD.currentUser.id) {
                results.append(activity)
            }
        }
        return results.sorted(by: {$0.wrappedValue.date < $1.wrappedValue.date})
    }
    
    func distanceToKilometers(activity: Binding<Activity>) -> Double? {
        let distance = lM.locationManager?.location?
            .distance(from:
                        CLLocation(latitude: activity.wrappedValue.coordinates[0],
                                   longitude: activity.wrappedValue.coordinates[1]))
        guard distance != nil else {
            return nil
        }
        return distance!
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
