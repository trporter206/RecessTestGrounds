//
//  ActivityListView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI
import CoreLocation

struct ActivityListView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @State var searchText = ""
    @State var showingMap = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Activities")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                MapButtonView(showingMap: $showingMap)
                if showingMap {
                    DashboardMapView()
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView(.vertical) {
                        VStack() {
                            ActiveActivitiesListView()
                                .environmentObject(tD)
                                .environmentObject(lM)
                            ActivitiesNearbyListView()
                                .environmentObject(tD)
                                .environmentObject(lM)
                        }
                    }
                    .background(Color("LightBlue"))
                }
            }
        }
    }
}

struct CreateActivityLinkView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationLink(destination: CreateActivityView().environmentObject(lM)
            .environmentObject(tD), label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.orange)
                    .frame(width: 300, height: 60)
                Text("Create Activity")
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
        })
    }
}

struct ActiveActivitiesListView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    
    var body: some View {
        Text("Active Activities")
            .modifier(SectionHeader())
        ScrollView(.horizontal) {
            HStack {
                ForEach($tD.activities.filter({$0.wrappedValue.currentlyActive})) { $activity in
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
    }
}

struct ActivitiesNearbyListView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    
    var body: some View {
        Text("Activities Nearby")
            .modifier(SectionHeader())
        //sort by distance
        ForEach($tD.activities.sorted(by: {distanceToMeters(activity: $0) <
                                           distanceToMeters(activity: $1)}))
        {$activity in
            if distanceToMeters(activity: $activity) <= 100000 {
                ActivityListItem(activity: $activity)
                    .environmentObject(lM)
                    .environmentObject(tD)
                    .padding([.leading, .trailing])
            }
        }
    }
    
    func distanceToMeters(activity: Binding<Activity>) -> Double {
        let distance = lM.locationManager?.location?
            .distance(from:
                        CLLocation(latitude: activity.wrappedValue.coordinates[0],
                                   longitude: activity.wrappedValue.coordinates[1]))
        guard distance != nil else {
            return 0.0
        }
        return distance!
    }
}

//struct ActivityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListView()
//            .environmentObject(TestData())
//            .environmentObject(LocationManager())
//    }
//}
