//
//  ActivityAnnotationDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-02.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityAnnotationDetailView: View {
    var activity: Binding<Activity>
    var tD: TestData
    var lM: LocationManager
    @State var userInfo: User = usersData[0]
    @State var playerlist: [User] = []
    @State var showingReviewSheet = false
    @State var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.wrappedValue.coordinates[0], longitude: activity.wrappedValue.coordinates[1]))
                    .frame(height: 260)
                PlayerProfileLink(activity: activity.wrappedValue, userInfo: $userInfo)
                    .environmentObject(tD)
                ActivityDescription(activity: activity.wrappedValue)
                Divider().padding([.leading, .trailing])
                ActivityStatus(activity: activity)
                ActivityPlayerList(playerList: $playerlist)
                ActivityDateView(activity: activity.wrappedValue)
                ActivityActionButtonView(activity: activity, playerList: $playerlist, showingReview: $showingReviewSheet)
                    .environmentObject(tD)
                    .environmentObject(lM)
//                ActivityDeleteButton(activity: activity, showingAlert: $showingAlert)
//                    .environmentObject(tD)
            }
            .onAppear {
                FirestoreService.shared.getUserInfo(id: activity.wrappedValue.creator) {
                    result in
                    switch result {
                    case .success(let user):
                        userInfo = user
                    case .failure(let error):
                        print("Error decoding creator info: \(error)")
                    }
                }
                playerlist = []
                for id in activity.wrappedValue.players {
                    FirestoreService.shared.getUserInfo(id: id) {result in
                        switch result {
                        case .success(let user):
                            playerlist.append(user)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            
        }
        .background(Color("LightBlue"))
        .sheet(isPresented: $showingReviewSheet, content: {
            ActivityReviewView(activity: activity, playerList: $playerlist, presentationMode: _presentationMode)
        })
    }
}

//struct ActivityAnnotationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityAnnotationDetailView(activity: BindingactivitiesData[0], tD: TestData(), lM: LocationManager())
//    }
//}
