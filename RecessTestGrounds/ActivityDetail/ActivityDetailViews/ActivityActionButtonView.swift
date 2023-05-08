//
//  ActivityActionButtonView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct ActivityActionButtonView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    @State var joined = false
    @Binding var playerList: [User]
    @Binding var showingReview: Bool
    
    let activityref = Firestore.firestore().collection("Activities")
    
    var body: some View {
        VStack {
            if $tD.currentUser.id == activity.creator {
                if activity.currentlyActive {
                    Button(action: {
                        showingReview.toggle()
                    }, label: {
                        ActivityButton("End Activity")
                    })
                } else {
                    if distanceToMeters(activity: $activity) > 100 {
                        Text("You must be within 100 meters of your activity to start")
                            .bold()
                            .foregroundColor(.orange)
                            .padding()
                    } else {
                        Button(action: {
                            activity.currentlyActive = true
                        }, label: {
                            ActivityButton("Start Activity")
                        })
                    }
                }
            } else {
                if joined {
                    Button(action: {
                        removePlayer()
                        joined = false
                    }, label: {
                        ActivityButton("Leave Activity")
                    })
                } else {
                    Button(action: {
                        addPlayer()
                        joined = true
                    }, label: {
                        ActivityButton("Join Activity")
                    })
                }
            }
        }
        .onAppear {
            checkJoined()
        }
    }
}

extension ActivityActionButtonView {
    
    func distanceToMeters(activity: Binding<Activity>) -> Double {
        let distance = lM.locationManager?.location?
            .distance(from:
                        CLLocation(latitude: activity.wrappedValue.coordinates[0],
                                   longitude: activity.wrappedValue.coordinates[1]))
        guard distance != nil else {
            return 0.0
        }
        return distance!
    }
    
    func checkJoined() {
        if activity.players.contains(tD.currentUser.id) {
            joined = true
        } else {
            joined = false
        }
    }
    
    func makeActive() {
        activity.currentlyActive = true
        activityref.document(activity.id).updateData([
            "currentlyActive" : true
        ])
    }
    
    func addPlayer() {
        activity.addPlayer(tD.currentUser) //maintain info when leaving view
        playerList.append(tD.currentUser)  //update view on click
        activityref.document(activity.id).updateData([ //update database
            "players" : FieldValue.arrayUnion([tD.currentUser.id]),
            "playerCount" : FieldValue.increment(Int64(1))
        ])
    }
    
    func removePlayer() {
        activity.removePlayer(tD.currentUser)
        playerList.removeAll(where: {$0.id == tD.currentUser.id})
        activityref.document(activity.id).updateData([
            "players" : FieldValue.arrayRemove([tD.currentUser.id]),
            "playerCount" : FieldValue.increment(Int64(-1))
        ])
    }
}

//struct ActivityActionButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityActionButtonView(activity: .constant(TestData().activities[0]), playerList: .constant([]), showingReview: .constant(false))
//            .environmentObject(TestData())
//    }
//}
