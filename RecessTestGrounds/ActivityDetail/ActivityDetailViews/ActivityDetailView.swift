//
//  ActivityDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-31.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityDetailView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
//    @StateObject var vM = ViewModel()
    @State var userInfo: User = usersData[0]
    @State var playerlist: [User] = []
    @State var showingReviewSheet = false
    @State var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.coordinates[0], longitude: activity.coordinates[1]))
                    .frame(height: 260)
                PlayerProfileLink(activity: activity,
                                  userInfo: $userInfo)
                ActivityDescription(activity: activity)
                Divider().padding([.leading, .trailing])
                ActivityStatus(activity: $activity)
                ActivityPlayerList(playerList: $playerlist)
                ActivityDateView(activity: activity)
                ActivityActionButtonView(activity: $activity,
                                         playerList: $playerlist,
                                         showingReview: $showingReviewSheet).environmentObject(tD).environmentObject(lM)
                HStack {
                    EditActivityButton(activity: $activity).environmentObject(tD).environmentObject(lM)
                    ActivityDeleteButton(activity: $activity,
                                         showingAlert: $showingAlert)
                }
            }
            .onAppear {
//                onAppear(activity, vM)
                FirestoreService.shared.getUserInfo(id: activity.creator) {
                    result in
                    switch result {
                    case .success(let user):
                        userInfo = user
                    case .failure(let error):
                        print("Error decoding creator info: \(error)")
                    }
                }
                playerlist = []
                for id in activity.players {
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
            ActivityReviewView(activity: $activity, playerList: $playerlist, presentationMode: _presentationMode)
        })
    }
}

//struct ActivityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityDetailView(activity: .constant(activitiesData[0]))
//            .environmentObject(TestData())
//    }
//}
