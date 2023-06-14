//
//  DashboardView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import CoreLocation

struct DashboardView: View {
//    @EnvironmentObject var appleDelegate: NotificationsController
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @State var showingMap = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                MyProfileHeader(user: tD.currentUser)
                VStack() {
                    HStack {
                        CreateActivityLinkView()
                        ExploreButton()
                    }
                        .environmentObject(tD)
                        .environmentObject(lM)
                    ScheduledActivitiesListView()
                        .environmentObject(tD)
                        .environmentObject(lM)
                    .padding(.bottom)
                }
            }
            .background(Color("LightBlue"))
//            onAppear {
//                appleDelegate.resetBadgeNumber()
//            }
        }
    }
}

struct ExploreButton: View {
    @EnvironmentObject var lM: LocationManager
    var body: some View {
        NavigationLink(destination: ExploreMapView().environmentObject(lM), label: {
            ZStack {
                Text("Explore")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 50)
                        .frame(width: 100)
                        .foregroundColor(.orange))
            }
            .padding()
        })
    }
}

struct CreateActivityLinkView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationLink(destination: CreateActivityView().environmentObject(lM)
            .environmentObject(tD), label: {
                ZStack {
                    Text("Create")
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 50)
                            .frame(width: 100)
                            .foregroundColor(.orange))
                }
                .padding()
        })
    }
}

struct ScheduledActivitiesListView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    
    var body: some View {
        VStack {
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
                Text("No Activities Scheduled, consider creating one!")
                    .foregroundColor(Color("TextBlue"))
                    .bold()
                    .padding()
            }
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
