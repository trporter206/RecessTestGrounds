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
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )
    @Binding var activityData: Activity.Data
    @State var chosenCoords = [0.0,0.0]
    @Binding var sport: String
    @State var locations: [Location] = []
    @State private var showingInfo = false
    @State private var selectedLocation: Location? = nil

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0], longitude: location.coordinates[1])) {
                    if sport == location.sport {
                        LocationAnnotationView(location: location, selectedCoords: $chosenCoords)
                            .onTapGesture {
                                chosenCoords = [location.coordinates[0], location.coordinates[1]]
                            }
                            .onLongPressGesture {
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
                    activityData.coordinates = [chosenCoords[0], chosenCoords[1]]
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    ActivityButton("Save Location")
                })
                .disabled(chosenCoords == [0.0,0.0])
            }
        }
        .onAppear {
            locations = mapLocations
            if let userLocation = lM.locationManager?.location?.coordinate {
                print("User location found")
                region.center = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
            }
        }
    }
}

struct LocationDetailsView: View {
    @State var location: Location
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack(spacing: 1) {
                    Text(location.name)
                        .font(.title)
                        .bold()
                        .padding(.top)
                    Text(location.address)
                        .font(.caption)
                        .textSelection(.enabled)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color("TextBlue"))
                Text(location.notes)
                    .padding()
//                if location.currentActivities.count == 0 {
//                    Text("No activities scheduled here")
//                } else {
//                    Text("Current scheduled activities:")
//                    ForEach($location.currentActivities) { $activity in
//                        ActivityListItem(activity: $activity)
//                    }
//                }
                if let description = location.about {
                    Text(description).padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("TextBlue"))
        .background(.white)
    }
}




