//
//  DashboardMapView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import MapKit

struct DashboardMapView: View {
    @EnvironmentObject var tD: TestData
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.568978, longitude: -122.673523),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    )

    var body: some View {
        VStack {
            Text("\(activitiesData.count) Activities")
            Map(coordinateRegion: $region, annotationItems: tD.activities) { activity in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: activity.coordinates[0], longitude: activity.coordinates[1])) {
                    ActivityAnnotationView(activity: activity)
                }
            }
        }
    }
}

struct DashboardMapView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardMapView()
            .environmentObject(TestData())
    }
}
