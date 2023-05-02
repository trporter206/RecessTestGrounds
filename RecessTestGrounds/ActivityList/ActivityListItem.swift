//
//  ScheduledActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityListItem: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @State var userInfo = usersData[0]
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: $activity).environmentObject(lM)
            .environmentObject(tD), label: {
            HStack {
                ProfilePicView(profileString: userInfo.profilePicString, height: 90)
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
                        Text(activity.date, format: .dateTime.day().month()).fontWeight(.light)
                    }
                    .foregroundColor(Color("TextBlue"))
                }
                if distanceToKilometers() != nil {
                    Text("\(distanceToKilometers()!)km")
                        .foregroundColor(Color("TextBlue"))
                        .padding()
                }
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: 1))
        })
        .onAppear {
            getCreatorInfo()
            dateFormatter.dateFormat = "M/d, h:mma"
        }
    }
}

extension ActivityListItem {
    func getCreatorInfo() {
        Firestore.firestore().collection("Users").document(activity.creator).getDocument() { documentSnapshot, error in
            if let error = error {
                print("Error getting creator info: \(error)")
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    userInfo = user
                } catch {
                    print("Error decoding creator info: \(error)")
                }
            }
        }
    }
    
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
