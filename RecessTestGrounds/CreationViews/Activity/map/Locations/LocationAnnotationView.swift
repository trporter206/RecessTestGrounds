//
//  LocationAnnotationView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import SwiftUI
import CoreLocation

struct LocationAnnotationView: View {
    var location: Location?
    dynamic var coordinate: CLLocationCoordinate2D
    
    init(location: Location) {
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinates[0], longitude: location.coordinates[1])
    }
    
    func getIcon(_ location: Location) -> String {
        switch location.sport {
        case "Baseball":
            return "figure.baseball"
        case "Basketball":
            return "figure.basketball"
        case "Volleyball":
            return "figure.volleyball"
        case "Soccer":
            return "figure.soccer"
        case "Football":
            return "figure.football"
        case "Rugby":
            return "figure.rugby"
        case "Tennis":
            return "figure.tennis"
        default:
            return "figure.stand"
        }
    }
    
    var body: some View {
        if let location = location {
            Image(systemName: getIcon(location))
                .padding()
                .background(Circle().fill(.white))
                .shadow(radius: 1)
        } else {
            EmptyView()
        }
    }
}

//struct LocationAnnotationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationAnnotationView()
//    }
//}
