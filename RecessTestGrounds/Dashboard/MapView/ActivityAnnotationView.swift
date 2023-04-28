//
//  ActivityAnnotationView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityAnnotationView: View {
    var activity: Activity
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String
    var frameSize: CGSize = CGSize(width: 100, height: 60)
    
    init(activity: Activity) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.coordinates[0], longitude: activity.coordinates[1])
        self.title = activity.sport
    }
    
    var body: some View {
        VStack {
            ProfilePicView(user: activity.creator, height: 35)
            VStack {
                Text(activity.sport)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("\(activity.date.formatted(.dateTime.day().month()))")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(8)
            .background(Color("TextBlue"))
            .cornerRadius(5)
        }
        .frame(width: frameSize.width, height: frameSize.height)
    }
}

extension ActivityAnnotationView {
    @ViewBuilder
    func getIcon(_ sport: String) -> some View {
        switch sport {
        case "Basketball": Image(systemName: "figure.basketball").foregroundColor(Color("TextBlue"))
        case "Soccer": Image(systemName: "figure.soccer").foregroundColor(Color("TextBlue"))
        default:
            Image(systemName: "figure.run").foregroundColor(Color("TextBlue"))
        }
        
    }
    
    func getCreatorIcon() -> some View {
        var imageString = ""
        Firestore.firestore().collection("Users").document(activity.creator).getDocument() { documentSnapshot, error in
            if let error = error {
                print("Error getting creator info: \(error)")
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    imageString = user.profilePicString
                } catch {
                    print("Error decoding creator info: \(error)")
                }
            }
        }
        return Image(systemName: imageString)
    }
}

struct ActivityAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAnnotationView(activity: activitiesData[0])
    }
}
