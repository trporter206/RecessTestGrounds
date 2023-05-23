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
    var activity: Binding<Activity>
    var tD: TestData
    var lM: LocationManager
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String
    var frameSize: CGSize = CGSize(width: 200, height: 50)
    @State var imageString = ""
    
    init(activity: Binding<Activity>, tD: TestData, lM: LocationManager) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.wrappedValue.coordinates[0], longitude: activity.wrappedValue.coordinates[1])
        self.title = activity.wrappedValue.sport
        self.tD = tD
        self.lM = lM
    }
    
    var body: some View {
        NavigationLink(destination: ActivityAnnotationDetailView(activity: activity, tD: tD, lM: lM), label: {
            HStack {
                ProfilePicView(profileString: imageString, height: 50)
                VStack(alignment: .leading) {
                    ActivityListItemHeader(activity: activity.wrappedValue)
                    ActivityListItemInfo(activity: activity.wrappedValue)
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
        Firestore.firestore().collection("Users").document(activity.wrappedValue.creator).getDocument() { documentSnapshot, error in
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

//struct ActivityAnnotationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityAnnotationView(activity: activitiesData[0], tD: TestData())
//    }
//}
