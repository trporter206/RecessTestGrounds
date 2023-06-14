//
//  ActivityMapView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-02.
//

import Foundation
import SwiftUI
import MapKit
import UIKit

struct ActivityDetailMapView: UIViewRepresentable {
    @EnvironmentObject var lM: LocationManager
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let map = MKMapView()
        map.setRegion(MKCoordinateRegion(center: coordinate,
                                         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                                         animated: true)
        view.addSubview(map)
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: view.widthAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            map.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // do nothing
    }
    
    typealias UIViewType = UIView
    
    
}
