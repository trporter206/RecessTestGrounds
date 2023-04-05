//
//  ScheduledActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import CoreLocation

struct ActivityListItem: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: $activity), label: {
            HStack {
                ProfilePicView(user: $activity.creator, height: 90)
                VStack(alignment: .leading) {
                    Text(activity.sport)
                        .font(.title)
                        .lineLimit(1)
                        .foregroundColor(Color("TextBlue"))
                        .bold()
                    HStack {
                        Text("\(activity.playerCount)/\(activity.maxPlayers)")
                            .fontWeight(.light)
                        Image(systemName: "person.3.fill")
                        Text("\(activity.date)").fontWeight(.light)
                        Image(systemName: "calendar")
                    }
                    .foregroundColor(Color("TextBlue"))
                }
                if distanceToKilometers() != nil {
                    VStack {
                        Image(systemName: "mappin")
                            .font(.system(size: 25))
                        Text("\(distanceToKilometers()!)km")
                    }
                    .foregroundColor(Color("TextBlue"))
                    .padding()
                }
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: 1))
        })
    }
}

extension ActivityListItem {
    func convertDistanceToDouble(_ distance: CLLocationDistance) -> Double {
        let distanceInMeters = distance.rounded()
        let distanceInKilometers = distanceInMeters / 1000
        return round(100 * distanceInKilometers) / 100
    }

    func removeTrailingZeros(_ value: Double) -> String {
        let stringValue = String(format: "%.2f", value)
        return stringValue.trimmingCharacters(in: ["0"])
    }

    func distanceToKilometers() -> String? {
        let distance = lM.locationManager?.location?
            .distance(from:
                CLLocation(latitude: activity.coordinates[0],
                           longitude: activity.coordinates[1]))

        guard distance != nil else {
            return nil
        }
        let distanceInKilometers = convertDistanceToDouble(distance!)
        return removeTrailingZeros(distanceInKilometers)
    }
}

struct ScheduledActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListItem(activity: .constant(activitiesData[0]))
            .environmentObject(LocationManager())
    }
}
