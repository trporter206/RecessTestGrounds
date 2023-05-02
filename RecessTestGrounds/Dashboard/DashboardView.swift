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
    @State var showingMap = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                MyProfileHeader(user: tD.currentUser)
                VStack() {
                    Button(action: {
                        showingMap.toggle()
                    }, label: {
                        Text("Show Map")
                            .foregroundColor({showingMap ? Color.red : Color.green}())
                    })
                    if showingMap {
                        DashboardMapView()
                            .frame(height: 500)
                    } else {
                        if scheduled().count > 0 {
                            Text("Your Next Activity")
                                .modifier(SectionHeader())
                            NextActivityView(activity: scheduled()[0])
                                .environmentObject(lM)
                                .environmentObject(tD)
                        } else {
                            Text("No Activities Scheduled")
                        }
                        Text("Your Scheduled Activities: \(scheduled().dropFirst().count)")
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
