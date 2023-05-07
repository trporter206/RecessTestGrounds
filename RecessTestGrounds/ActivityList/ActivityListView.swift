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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                Text("Activities")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                VStack() {
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
                    Text("Activities Starting Soon")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($tD.activities.filter({isDateWithinNext24Hours($0.date.wrappedValue)})) { $activity in
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
                    Text("Looking for 1 more")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(needsOneMore()) { $activity in
                                ActivityListItem(activity: $activity)
                                    .environmentObject(lM)
                                    .environmentObject(tD)
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                    }
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
            }
            .background(Color("LightBlue"))
        }
    }
}

extension ActivityListView {
    func isDateWithinNext24Hours(_ date: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Add 24 hours to the current date
        if let date24HoursLater = calendar.date(byAdding: .hour, value: 24, to: currentDate) {
            // Check if the given date is between the current date and the date 24 hours later
            if date >= currentDate && date <= date24HoursLater {
                return true
            }
        }
        
        return false
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
    
    func needsOneMore() -> [Binding<Activity>] {
        var results : [Binding<Activity>] = []
        for activity in $tD.activities {
            if activity.wrappedValue.players.count == activity.wrappedValue.maxPlayers - 1 {
                results.append(activity)
            }
        }
        return results
    }
    
    
}

//struct ActivityListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListView()
//            .environmentObject(TestData())
//            .environmentObject(LocationManager())
//    }
//}
