//
//  DashboardMapView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import MapKit

struct DashboardMapView: UIViewRepresentable {
    
    @Binding var annotations: [ActivityAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // remove all previous annotations
        uiView.removeAnnotations(uiView.annotations)
        // add new annotations to the map
        uiView.addAnnotations(annotations)
        
        // zoom to fit all annotations
        uiView.showAnnotations(annotations, animated: true)
        
    }
}

struct DashboardMapView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardMapView(annotations: .constant([ActivityAnnotation(activity: TestData().activities[0])]))
    }
}
