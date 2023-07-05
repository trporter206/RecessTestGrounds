//
//  LocationAnnotationView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import SwiftUI
import CoreLocation

struct LocationAnnotationView: View {
    var location: Location
    var title: String
    var coordinate: CLLocationCoordinate2D
    @Binding var selectedLocation: Location?
    var frameSize: CGSize = CGSize(width: 24, height: 24)
    
    init(location: Location, selectedLocation: Binding<Location?>) {
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinates[0][0], longitude: location.coordinates[0][1])
        self.title = location.name
        self._selectedLocation = selectedLocation
    }
    
    var body: some View {
        Image(systemName: "leaf")
            .resizable() // Makes the image resizable
            .scaledToFit()
            .frame(width: frameSize.width, height: frameSize.height)
            .bold()
            .foregroundColor(selectedLocation?.name == location.name ? .orange : Color("TextBlue"))
            .padding(8)
            .background(Circle()
                .fill(.white)
                .shadow(radius: 1))
    }

}


//struct LocationAnnotationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationAnnotationView(location: Location(sport: "Basketball", coordinates: [0.0,0.0], notes: "", address: ""), selectedCoords: .constant([]))
//    }
//}
