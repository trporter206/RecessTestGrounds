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
    @StateObject var vM = ViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.coordinates[0], longitude: activity.coordinates[1]))
                    .frame(height: 260)
                PlayerProfileLink(activity: activity,
                                  userInfo: $vM.userInfo)
                ActivityDescription(activity: activity)
                Divider().padding([.leading, .trailing])
                ActivityStatus(activity: $activity)
                ActivityPlayerList(playerList: $vM.playerlist)
                ActivityDateView(activity: activity)
                ActivityActionButtonView(activity: $activity,
                                         playerList: $vM.playerlist,
                                         showingReview: $vM.showingReviewSheet).environmentObject(tD).environmentObject(lM)
                HStack {
                    EditActivityButton(activity: $activity).environmentObject(tD).environmentObject(lM)
                    ActivityDeleteButton(activity: $activity,
                                         showingAlert: $vM.showingAlert)
                }
            }
            .onAppear {
                onAppear(activity, vM)
            }
            
        }
        .background(Color("LightBlue"))
        .sheet(isPresented: $vM.showingReviewSheet, content: {
            ActivityReviewView(activity: $activity, playerList: $vM.playerlist, presentationMode: _presentationMode)
        })
    }
}

//struct ActivityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityDetailView(activity: .constant(activitiesData[0]))
//            .environmentObject(TestData())
//    }
//}
