//
//  TestData.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class TestData: ObservableObject {
    @Published var users = usersData
    @Published var clubs = clubsData
    @Published var activities: [Activity] = []
    @Published var currentUser = usersData[0]
    @Published var loggedIn = false
    
    let activitiesRef = Firestore.firestore().collection("Activities")
    
    init() {
        getActivities()
    }
    
    func getActivities() {
        activities = []
        activitiesRef.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting activity documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let activity = try document.data(as: Activity.self)
                        //delete activity if it is older than 24 hours, else add to list
                        if Date.now.timeIntervalSince(activity.date) > 86400 {
                            self.activitiesRef.document(activity.id).delete()
                        } else {
                            self.activities.append(activity)
                        }
                    } catch {
                        print("Error decoding activity documents: \(error)")
                    }
                }
            }
        }
    }
}




var usersData: [User] = [
    User(name: "Temp User", email: "test@email.com", avatar: "3d_avatar_1")
]

var activitiesData: [Activity] = [
    Activity(sport: "Basketball",
             maxPlayers: 5,
             date: Date.now,
             description: "Casual game downtown. Come join the crew!",
             coordinates: [45.568978, -122.673523],
             creator: usersData[0].id)
]

var clubsData: [Club] = [
    Club(id: UUID().uuidString,
         creator: usersData[0],
         name: "Portland Blacktop",
         sport: "Basketball",
         members: usersData,
         numActivities: 12,
         type: "Paid",
         description: "For Portlanders who are serious weekend warriors looking to improve their game")
]

var avatarStrings: [String] = [
    "3d_avatar_1",
    "3d_avatar_3",
    "3d_avatar_18",
    "3d_avatar_21",
    "3d_avatar_29",
    "3d_avatar_30",
]
