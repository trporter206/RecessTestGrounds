//
//  ActivityActionButtonView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import FirebaseFirestore

struct ActivityActionButtonView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @State var joined = false
    @Binding var playerList: [User]
    
    let activityref = Firestore.firestore().collection("Activities")
    
    var body: some View {
        VStack {
            if $tD.currentUser.id == activity.creator {
                if activity.currentlyActive {
                    NavigationLink(destination: ActivityReviewView(activity: $activity), label: {
                        ActivityButton("End Activity")
                    })
                } else {
                    Button(action: {
                        activity.currentlyActive = true
                    }, label: {
                        ActivityButton("Start Activity")
                    })
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
        activity.addPlayer(tD.currentUser)
        playerList.append(tD.currentUser)
        activityref.document(activity.id).updateData([
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
    
    @ViewBuilder
    func ActivityButton(_ text: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.orange)
                .frame(width: 300, height: 60)
            Text(text)
                .foregroundColor(.white)
                .bold()
        }
        .padding()
    }
}

struct ActivityActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityActionButtonView(activity: .constant(TestData().activities[0]), playerList: .constant([]))
            .environmentObject(TestData())
    }
}
