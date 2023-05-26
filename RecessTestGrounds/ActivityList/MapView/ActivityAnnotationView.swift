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
    var activity: Binding<Activity>?
    var tD: TestData
    var lM: LocationManager
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String
    var frameSize: CGSize = CGSize(width: 300, height: 50)
    @State var imageString = ""
    
    init(activity: Binding<Activity>, tD: TestData, lM: LocationManager) {
        self.activity = activity
        self.coordinate = CLLocationCoordinate2D(latitude: activity.wrappedValue.coordinates[0], longitude: activity.wrappedValue.coordinates[1])
        self.title = activity.wrappedValue.sport
        self.tD = tD
        self.lM = lM
    }
    
    var body: some View {
        if let activityVal = activity {
            NavigationLink(destination: ActivityAnnotationDetailView(activity: activityVal, tD: tD, lM: lM), label: {
                ZStack(alignment: .leading) {
                    HStack {
                        if imageString != "" {
                            ProfilePicView(profileString: imageString, height: 50)
                        }
                        VStack(alignment: .leading) {
                            ActivityListItemHeader(activity: activityVal.wrappedValue)
                                .font(.caption)
                            ActivityListItemInfo(activity: activityVal.wrappedValue)
                                .font(.caption)
                        }
                        .foregroundColor(Color("TextBlue"))
                    }
                    .padding(.trailing)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                    )
                }
            })
            .frame(width: frameSize.width, height: frameSize.height)
            .onAppear {
                FirestoreService.shared.getUserInfo(id: activityVal.wrappedValue.creator) { result in
                    switch result {
                    case .success(let user):
                        imageString = user.profilePicString
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct ActivityAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAnnotationView(activity: .constant(activitiesData[0]), tD: TestData(skipFetching: true), lM: LocationManager())
    }
}
