//
//  ExploreMapView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-14.
//

import SwiftUI
import CoreLocation
import MapKit

struct ExploreMapView: View {
    @EnvironmentObject var lM: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State var locations: [Location] = []
    @State var sport: String = sportOptions[0]
    @State private var showingInfo = false
    @State private var selectedLocation: Location? = nil
    @State private var chosenCoords: [Double] = [0.0,0.0]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locations) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0], longitude: location.coordinates[1])) {
                    if sport == location.sport {
                        LocationAnnotationView(location: location, selectedCoords: $chosenCoords)
                            .onTapGesture {
                                selectedLocation = location
                                chosenCoords = location.coordinates
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
                Text("Tap for info")
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
                .background(RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.white)
                    .shadow(radius: 1))
                .padding()
                Spacer()
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

//struct ExploreMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreMapView()
//    }
//}
