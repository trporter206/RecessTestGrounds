//
//  DashboardMapView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import MapKit

class DashboardMapCoordinator: NSObject, MKMapViewDelegate {
    var dashboardMapView: DashboardMapView

    init(_ dashboardMapView: DashboardMapView) {
        self.dashboardMapView = dashboardMapView
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let activityAnnotation = annotation as? ActivityAnnotation {
            let identifier = "ActivityAnnotationView"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            let customView = ActivityAnnotationView(activity: activityAnnotation.activity, tD: activityAnnotation.tD, lM: activityAnnotation.lM)
            
            let hostingController = UIHostingController(rootView: customView)
            hostingController.view.backgroundColor = .clear
            hostingController.view.frame = CGRect(origin: .zero, size: customView.frameSize)
            
            annotationView.addSubview(hostingController.view)
            annotationView.frame = hostingController.view.frame
            annotationView.clusteringIdentifier = "activity"
            
            return annotationView
        } else if let cluster = annotation as? MKClusterAnnotation {
            let identifier = "Cluster"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.displayPriority = .defaultHigh
            annotationView.clusteringIdentifier = "activity"
            annotationView.glyphText = "\(cluster.memberAnnotations.count)"
            annotationView.markerTintColor = UIColor(named: "TextBlue")
            return annotationView
        }
        
        return nil
    }
}



struct DashboardMapView: UIViewRepresentable {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @Binding var filteredActivites: [Activity]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.267155, longitude: -123.116873),
        span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
    )

    func makeCoordinator() -> DashboardMapCoordinator {
        DashboardMapCoordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        // Set the initial region to user's location if available
        if let userLocation = lM.locationManager?.location?.coordinate {
                mapView.setRegion(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                ), animated: false)
        }

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let existingAnnotations = view.annotations
        view.removeAnnotations(existingAnnotations)
        let newAnnotations = $filteredActivites.map { ActivityAnnotation(activity: $0, tD: tD, lM: lM) }
        view.addAnnotations(newAnnotations)
    }
}


struct DashboardMapView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardMapView(filteredActivites: .constant([]))
            .environmentObject(TestData())
    }
}
