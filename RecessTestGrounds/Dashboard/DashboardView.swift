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
                    MapButtonView(showingMap: $showingMap)
                    if showingMap {
                        DashboardMapView()
                            .frame(height: 500)
                    } else {
                        ScheduledActivitiesListView()
                            .environmentObject(tD)
                            .environmentObject(lM)
                        .padding(.bottom)
                    }
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

struct MapButtonView: View {
    @Binding var showingMap: Bool
    
    var body: some View {
        Button(action: {
            showingMap.toggle()
        }, label: {
            Text("Show Map")
                .foregroundColor({showingMap ? Color.red : Color.green}())
        })
    }
}

struct ScheduledActivitiesListView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    
    var body: some View {
        if scheduled().count > 0 {
            Text("Your Next Activity")
                .modifier(SectionHeader())
            NextActivityView(activity: scheduled()[0])
                .environmentObject(lM)
                .environmentObject(tD)
            Text("Other Scheduled Activities: \(scheduled().dropFirst().count)")
                .modifier(SectionHeader())
            ForEach(scheduled().dropFirst()) { $activity in
                if $activity.wrappedValue.players.contains(tD.currentUser.id) {
                    ActivityListItem(activity: $activity)
                        .environmentObject(lM)
                        .environmentObject(tD)
                        .padding([.leading, .trailing])
                }
            }
        } else {
            Text("No Activities Scheduled")
        }
    }
    
    func scheduled() -> [Binding<Activity>] {
        var results: [Binding<Activity>] = []
        for activity in $tD.activities {
            if activity.wrappedValue.players.contains(tD.currentUser.id) {
                results.append(activity)
            }
        }
        return results.sorted(by: {$0.wrappedValue.date < $1.wrappedValue.date})
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//            .environmentObject(LocationManager())
//            .environmentObject(TestData())
//    }
//}
