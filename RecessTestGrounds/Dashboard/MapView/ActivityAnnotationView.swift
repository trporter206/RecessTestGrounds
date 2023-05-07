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
    var tD: TestData
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String
    var frameSize: CGSize = CGSize(width: 200, height: 50)
    @State var imageString = ""
    
    init(activity: Activity, tD: TestData) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.coordinates[0], longitude: activity.coordinates[1])
        self.title = activity.sport
        self.tD = tD
    }
    
    var body: some View {
//        NavigationLink(destination: ActivityAnnotationDetailView(activity: activity, tD: tD), label: {
//            VStack {
//                ProfilePicView(profileString: imageString, height: 35)
//                VStack {
//                    Text(activity.sport)
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                    Text("\(activity.date.formatted(.dateTime.day().month()))")
//                        .font(.subheadline)
//                        .foregroundColor(.white)
//                }
//                .padding(8)
//                .background(Color("TextBlue"))
//                .cornerRadius(5)
//            }
//        })
        NavigationLink(destination: ActivityAnnotationDetailView(activity: activity, tD: tD), label: {
            HStack {
                ProfilePicView(profileString: imageString, height: 50)
                VStack(alignment: .leading) {
                    Text(activity.sport)
                        .lineLimit(1)
                        .foregroundColor(Color("TextBlue"))
                    HStack {
                        Text("\(activity.playerCount)")
                            .font(.caption)
                        Image(systemName: "person.3.fill").bold()
                        Text(activity.date, format: .dateTime.day().month())
                            .font(.caption)
                    }
                    .padding(.trailing)
                    .foregroundColor(Color("TextBlue"))
                }
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: 1))
        })
        .frame(width: frameSize.width, height: frameSize.height)
        .onAppear {
            getCreatorIcon()
        }
    }
}

extension ActivityAnnotationView {
    
    func getCreatorIcon() {
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
    }
}

struct ActivityAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAnnotationView(activity: activitiesData[0], tD: TestData())
    }
}
