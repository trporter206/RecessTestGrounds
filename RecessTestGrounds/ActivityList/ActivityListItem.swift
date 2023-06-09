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
    @State var userInfo: User? = nil
    
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: $activity).environmentObject(lM).environmentObject(tD),
                       label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                HStack {
                    if let user = userInfo {
                        ProfilePicView(profileString: user.profilePicString, height: 80)
                    } else {
                        SportIcon(activity: activity)
                    }
                    VStack(alignment: .leading) {
                        ActivityListItemHeader(activity: activity)
                        ActivityListItemInfo(activity: activity)
                    }
                }
            }
            .padding([.bottom, .horizontal])
        })
        .onAppear {
            getUserInfo()
            dateFormatter.dateFormat = "M/d, h:mma"
        }
    }
}

struct ActivityListItemHeader: View {
    let activity: Activity
    
    var body: some View {
        if activity.title != "" {
            Text(activity.title)
                .font(.title2)
                .lineLimit(1)
                .foregroundColor(Color("TextBlue"))
                .bold()
        } else {
            Text(activity.sport)
                .font(.title2)
                .lineLimit(1)
                .foregroundColor(Color("TextBlue"))
                .bold()
                .padding(.trailing)
        }
    }
}

struct ActivityListItemInfo: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            Image(systemName: "person.3.fill")
            Text("\(activity.players.count)")
                .bold()
                .foregroundColor(.orange)
            Image(systemName: "calendar")
            Text(activity.date, format: .dateTime.day().month())
                .bold()
                .foregroundColor(.orange)
            ActivityListItemDistance(activity: activity)
        }
        .foregroundColor(Color("TextBlue"))
    }
}

struct ActivityListItemDistance: View {
    @EnvironmentObject var lM: LocationManager
    let activity: Activity
    
    var body: some View {
        if distanceToKilometers() != nil {
            HStack {
                Image(systemName: "location.fill")
                Text("\(distanceToKilometers()!)km")
                    .bold()
                    .foregroundColor(.orange)
            }
        }
    }
    
    func convertDistanceToDouble(_ distance: CLLocationDistance) -> Double {
        let distanceInMeters = distance.rounded()
        let distanceInKilometers = distanceInMeters / 1000
        return round(100 * distanceInKilometers) / 100
    }

    func removeTrailingZeros(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
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

struct SportIcon: View {
    let activity: Activity
    
    var body: some View {
        Image(systemName: getSportIcon(activity.sport))
            .resizable()
            .padding()
            .foregroundColor(Color("TextBlue"))
            .scaledToFit()
            .frame(width: CGFloat(90), height: CGFloat(90))
            .clipShape(Circle())
    }
    
    func getSportIcon(_ sport: String) -> String {
        switch activity.sport {
        case "Baseball":
            return "figure.baseball"
        case "Basketball":
            return "figure.basketball"
        case "Football":
            return "figure.american.football"
        case "Rugby":
            return "figure.rugby"
        case "Soccer":
            return "figure.soccer"
        case "Spikeball":
            return "figure.run"
        case "Tennis":
            return "figure.tennis"
        case "Volleyball":
            return "figure.volleyball"
        default:
            return "figure.run"
        }
    }
}

extension ActivityListItem {
    func getUserInfo() {
        guard tD.activities.contains(where: { $0.id == activity.id }) else {
            return
        }
        guard let activityIndex = tD.activities.firstIndex(where: { $0.id == activity.id }) else {
            print("Could not find activity index")
            return
        }
        FirestoreService.shared.getUserInfo(id: tD.activities[activityIndex].creator) {
            result in
            switch result {
            case .success(let user):
                userInfo = user
            case .failure(let error):
                print("Error decoding creator info: \(error)")
            }
        }
    }
}

//struct ScheduledActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityListItem(activity: .constant(activitiesData[0]))
//            .environmentObject(LocationManager())
//            .environmentObject(TestData())
//    }
//}
