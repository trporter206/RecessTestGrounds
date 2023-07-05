//
//  ChooseLocationMapView.swift
//  Recess2.0
//
//  Created by Torri Ray Porter Jr on 2023-03-03.
//

import Foundation
import MapKit
import SwiftUI

struct ActivityChooseLocalMap: View {
    @EnvironmentObject var lM: LocationManager
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var activityData: Activity.Data
    @Binding var sport: String
    
    @State var locations: [Location] = []
    @State private var showingInfo = false
    @State private var selectedLocation: Location? = nil
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
                LocationDetailsView(location: location)
                    .presentationDetents([.medium])
            }
            .ignoresSafeArea()
            VStack {
                Text("Tap to select, hold for info")
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    )
                Picker(sport, selection: $sport) {
                    ForEach(sportOptions, id: \.self) {
                        Text($0)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.white))
                .padding()
                Spacer()
                Button(action: {
                    activityData.coordinates = [selectedLocation!.coordinates[0][0], selectedLocation!.coordinates[0][1]]
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    ActivityButton("Save Location")
                })
                .disabled(selectedLocation == nil)
            }
        }
        .onAppear {
            locations = Array(mapLocations.filter({$0.sports.contains(sport)}))
            if let userLocation = lM.locationManager?.location?.coordinate {
                region.center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            }
        }
    }
}





