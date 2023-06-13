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
    var title: String
    dynamic var coordinate: CLLocationCoordinate2D
    @Binding var chosenCoords: [Double]
    var frameSize: CGSize = CGSize(width: 24, height: 24)
    
    init(location: Location, selectedCoords: Binding<[Double]>) {
        self.location = location
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinates[0], longitude: location.coordinates[1])
        self.title = location.sport
        self._chosenCoords = selectedCoords
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
                .resizable() // Makes the image resizable
                .scaledToFit()
                .frame(width: frameSize.width, height: frameSize.height)
                .bold()
                .foregroundColor(chosenCoords == location.coordinates ? .orange : Color("TextBlue"))
                .padding(8)
                .background(Circle()
                    .fill(.white)
                    .shadow(radius: 1))
                .onAppear {
                    
                }
        } else {
            EmptyView()
        }
    }

}

struct LocationAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAnnotationView(location: Location(sport: "Basketball", coordinates: [0.0,0.0], notes: "", address: ""), selectedCoords: .constant([]))
    }
}
