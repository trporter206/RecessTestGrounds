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
                if showingMap {
                    VStack(spacing: 0) {
                        ActivityFilterView(filteredActivities: $filteredActivities,
                                           showingMap: $showingMap)
                        DashboardMapView(filteredActivites: $filteredActivities)
                            .frame(maxHeight: .infinity)
                    }
                } else {
                    ScrollView(.vertical) {
                        VStack {
                            ActivityFilterView(filteredActivities: $filteredActivities,
                                               showingMap: $showingMap)
                            if filteredActivities.isEmpty {
                                Text("No Activities Nearby!")
                                    .foregroundColor(.orange)
                                    .bold()
                                    .padding()
                            } else {
                                Text("\(filteredActivities.count) Activities").padding()
                                ForEach($filteredActivities.sorted(by: {distanceToMeters(activity: $0) < distanceToMeters(activity: $1)}))
                                { $activity in
                                        ActivityListItem(activity: getActivity($activity))
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
    
    func getActivity(_ activity: Binding<Activity>) -> Binding<Activity> {
        let originalActivity = $tD.activities.first(where: {$0.id == activity.id})
        return originalActivity!
    }
}

//struct ActivityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListView()
//            .environmentObject(TestData())
//            .environmentObject(LocationManager())
//    }
//}
