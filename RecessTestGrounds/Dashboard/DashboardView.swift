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
    
    @State var showingMapView = false
    @State var annotations: [ActivityAnnotation] = []
    
    var body: some View {
        NavigationStack {
            if showingMapView {
                VStack {
                    DashboardHeaderView(user: $tD.currentUser, showingMap: $showingMapView)
                    DashboardMapView(annotations: $annotations)
                }
            } else {
                ScrollView(.vertical) {
                    DashboardHeaderView(user: $tD.currentUser, showingMap: $showingMapView)
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
                .background(Color("LightBlue"))
            }
        }
        .onAppear {
            annotations = getAnnotations()
        }
    }
}

extension DashboardView {
    func getAnnotations() -> [ActivityAnnotation] {
        var annotations: [ActivityAnnotation] = []
        for activity in tD.activities {
            annotations.append(ActivityAnnotation(activity: activity))
        }
        return annotations
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
