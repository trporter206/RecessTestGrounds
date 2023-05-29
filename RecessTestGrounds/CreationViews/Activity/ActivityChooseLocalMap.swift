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

struct CustomMapView: UIViewRepresentable {
    @EnvironmentObject var lM: LocationManager
    @Binding var selectedCoordinate: CLLocationCoordinate2D

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        if let userLocation = lM.locationManager?.location?.coordinate {
            print("User location found")
                mapView.setRegion(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                ), animated: false)
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
            mapView.addGestureRecognizer(longPressRecognizer)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }

        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
                let coordinate = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)

                if let coord = coordinate, let mapView = gestureRecognizer.view as? MKMapView {
                    parent.selectedCoordinate = coord

                    // Remove previous annotations
                    let currentAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
                    mapView.removeAnnotations(currentAnnotations)

                    // Add a new annotation for the selected coordinate
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }

}

struct ActivityChooseLocalMap: View {
    @EnvironmentObject var lM: LocationManager
    @State private var coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    @Binding var activityData: Activity.Data
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            CustomMapView(selectedCoordinate: $coords)
                .environmentObject(lM)
            .ignoresSafeArea()
            VStack {
                Text("Hold your finger down on the desired location")
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    )
                Spacer()
                Button(action: {
                    activityData.coordinates = [coords.latitude, coords.longitude]
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    ActivityButton("Save Location")
                })
            }
        }
    }
}




