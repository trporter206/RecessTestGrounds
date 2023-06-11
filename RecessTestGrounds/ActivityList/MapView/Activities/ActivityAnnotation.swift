//
//  ActivityAnnotation.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import Foundation
import MapKit
import SwiftUI

class ActivityAnnotation: NSObject, MKAnnotation {
    let activity: Binding<Activity>
    let coordinate: CLLocationCoordinate2D
    let tD: TestData
    let lM: LocationManager
    
    init(activity: Binding<Activity>, tD: TestData, lM: LocationManager) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.wrappedValue.coordinates[0], longitude: activity.wrappedValue.coordinates[1])
        self.tD = tD
        self.lM = lM
        super.init()
    }
}
