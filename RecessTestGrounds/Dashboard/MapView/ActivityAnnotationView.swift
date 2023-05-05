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
    var frameSize: CGSize = CGSize(width: 100, height: 60)
    @State var imageString = ""
    
    init(activity: Activity, tD: TestData) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.coordinates[0], longitude: activity.coordinates[1])
        self.title = activity.sport
        self.tD = tD
    }
    
    var body: some View {
        NavigationLink(destination: ActivityAnnotationDetailView(activity: activity, tD: tD), label: {
            VStack {
                ProfilePicView(profileString: imageString, height: 35)
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
