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
    @State var filteredActivities: [Activity] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                ActivityFilterView(filteredActivities: $filteredActivities,
                                   showingMap: $showingMap)
                if showingMap {
                    DashboardMapView(filteredActivites: $filteredActivities)
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView(.vertical) {
                        VStack {
                            if filteredActivities.isEmpty {
                                Text("No Activities Nearby!")
                            } else {
                                Text("\(filteredActivities.count) Activities").padding()
                                ForEach($filteredActivities.sorted(by: {distanceToMeters(activity: $0) < distanceToMeters(activity: $1)}))
                                { $activity in
                                        ActivityListItem(activity: $activity)
                                            .environmentObject(lM)
                                            .environmentObject(tD)
                                }
                            }
                        }
                    }
                    .background(Color("LightBlue"))
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

extension ActivityListView {
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
