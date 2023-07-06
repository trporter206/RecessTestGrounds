//
//  ChooseLocationMapView.swift
//  Recess2.0
//
//  Created by Torri Ray Porter Jr on 2023-03-03.
//

import Foundation
import MapKit
import SwiftUI
//TODO: improve performance of this page and get the selected location to stay
struct ActivityChooseLocalMap: View {
    @EnvironmentObject var lM: LocationManager
    
    @Binding var activityData: Activity.Data
    @Binding var sport: String
    @Binding var locationName: String
    
    @State var locations: [Location] = []
    @State private var showingInfo = false
    @State var selectedLocation: Location?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0][0], longitude: location.coordinates[0][1])) {
                    if location.sports.contains(sport) {
                        LocationAnnotationView(location: location, selectedLocation: $selectedLocation)
                            .onTapGesture {
                                selectedLocation = location
                                showingInfo = true
                            }
                    } else {
                        EmptyView()
                    }
                }
            }
            .sheet(item: $selectedLocation) { location in
                LocationDetailsView(exploreOnly: false,
                                    location: location,
                                    activityData: $activityData,
                                    locationName: $locationName)
                    .presentationDetents([.medium])
            }
            .ignoresSafeArea()
            VStack {
                Text("Tap to select")
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    )
                Picker(sport, selection: $sport) {
                    ForEach(sportOptions, id: \.self) {
                        Text("All").tag("All")
                        Text($0)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.white))
                .padding()
                Spacer()
//                ActivityButton(selectedLocation?.name ?? "Select a location")
            }
        }
        .onAppear {
            if sport == "All" {
                locations = mapLocations
            } else {
                locations = Array(mapLocations.filter({$0.sports.contains(sport)}))
            }
            if let userLocation = lM.locationManager?.location?.coordinate {
                region.center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            }
        }
    }
}





