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
    
    var body: some View {
        VStack {
            if $tD.currentUser.id == activity.creator {
                if activity.currentlyActive {
                    EndActivityButton(showingReview: $showingReview)
                } else {
                    StartActivityButton(activity: $activity)
                }
            } else {
                if joined {
                    LeaveActivityButton(joined: $joined, activity: $activity, playerList: $playerList)
                } else {
                    JoinActivityButton(joined: $joined, activity: $activity, playerList: $playerList)
                }
            }
        }
        .onAppear {
            checkJoined()
        }
    }
}

struct EndActivityButton: View {
    @Binding var showingReview: Bool
    
    var body: some View {
        Button(action: {
            showingReview.toggle()
        }, label: {
            ActivityButton("End Activity")
        })
    }
}

struct StartActivityButton: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    
    var body: some View {
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
}

struct LeaveActivityButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var joined: Bool
    @Binding var activity: Activity
    @Binding var playerList: [User]
    
    let activityref = Firestore.firestore().collection("Activities")
    
    var body: some View {
        Button(action: {
            removePlayer()
            joined = false
        }, label: {
            ActivityButton("Leave Activity")
        })
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

struct JoinActivityButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var joined: Bool
    @Binding var activity: Activity
    @Binding var playerList: [User]
    let activityref = Firestore.firestore().collection("Activities")
    
    var body: some View {
        Button(action: {
            addPlayer()
            joined = true
        }, label: {
            ActivityButton("Join Activity")
        })
    }
    
    func addPlayer() {
        activity.addPlayer(tD.currentUser) //maintain info when leaving view
        playerList.append(tD.currentUser)  //update view on click
        activityref.document(activity.id).updateData([ //update database
            "players" : FieldValue.arrayUnion([tD.currentUser.id]),
            "playerCount" : FieldValue.increment(Int64(1))
        ])
    }
}

extension ActivityActionButtonView {
    func checkJoined() {
        if activity.players.contains(tD.currentUser.id) {
            joined = true
        } else {
            joined = false
        }
    }
    
    func makeActive() {
        let activityref = Firestore.firestore().collection("Activities")
        activity.currentlyActive = true
        activityref.document(activity.id).updateData([
            "currentlyActive" : true
        ])
    }
}

//struct ActivityActionButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityActionButtonView(activity: .constant(TestData().activities[0]), playerList: .constant([]), showingReview: .constant(false))
//            .environmentObject(TestData())
//    }
//}
