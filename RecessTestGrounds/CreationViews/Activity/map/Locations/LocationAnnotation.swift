//
//  LocationAnnotation.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import SwiftUI
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    let location: Location
    let coordinate: CLLocationCoordinate2D
    
    init(location: Location, lM: LocationManager) {
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinates[0][0], longitude: location.coordinates[0][1])
        super.init()
    }
}

