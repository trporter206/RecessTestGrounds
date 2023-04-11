//
//  ChooseLocationMapView.swift
//  Recess2.0
//
//  Created by Torri Ray Porter Jr on 2023-03-03.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

struct Address: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let latitude, longitude: Double
    let name: String?
}

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject {
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "922a90ddb10834dbc5ffdd489763dc80"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates: [Double] = Array<Double>()
    @Published var locations: [Location] = []
    
    init() {
        let coords = CLLocationCoordinate2D(latitude: 45.572496, longitude: -122.671807)
        self.region = MKCoordinateRegion(center: coords,
                                         span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
        self.locations.insert(Location(name: "pin", coordinate: coords), at: 0)
    }
    
    func getLocation(address: String, delta: Double) {
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            if newCoordinates.data.isEmpty {
                print("Could not find address")
                return
            }
            DispatchQueue.main.async {
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                                 span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
                
                let newLocation = Location(name: name ?? "Pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                self.locations.removeAll()
                self.locations.insert(newLocation, at: 0)
            }
        }
        .resume()
    }
}

struct ActivityChooseLocalMap: View {
    @EnvironmentObject var lM: LocationManager
    @StateObject private var mapAPI = MapAPI()
    @Binding var addressText: String
    @State private var coords = [0.0,0.0]
    @Binding var activityData: Activity.Data
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapAPI.region, showsUserLocation: true, annotationItems: mapAPI.locations) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .ignoresSafeArea()
            VStack {
                TextField("Enter Location", text: $addressText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Find Location") {
                    mapAPI.getLocation(address: addressText, delta: 0.5)
                }
                Spacer()
                Button("Save") {
                    activityData.coordinates = mapAPI.coordinates
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            mapAPI.region = MKCoordinateRegion(center: lM.locationManager!.location!.coordinate,
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
}



