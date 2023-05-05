//
//  ActivityAnnotation.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import Foundation
import MapKit

class ActivityAnnotation: NSObject, MKAnnotation {
    let activity: Activity
    let coordinate: CLLocationCoordinate2D
    let tD: TestData
    
    init(activity: Activity, tD: TestData) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.coordinates[0], longitude: activity.coordinates[1])
        self.tD = tD
        super.init()
    }
}
