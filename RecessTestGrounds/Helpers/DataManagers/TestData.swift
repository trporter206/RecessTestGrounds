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
    
    init() {
        getActivities()
    }
    
    func getActivities() {
        activities = []
        Firestore.firestore().collection("Activities").getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting activity documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let activity = try document.data(as: Activity.self)
                        self.activities.append(activity)
                    } catch {
                        print("Error decoding activity documents: \(error)")
                    }
                }
            }
        }
    }
}




var usersData: [User] = [
    User(name: "Temp User", email: "test@email.com")
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

var myAchievements: [String] = [
    "Gold 1",
    "Gold",
    "GoldEmpty",
    "Medal1",
    "Star",
]
var allAchievements: [String] = [
    "2 color ribbon",
    "Black ribbon",
    "Blue ribbon",
    "Empty-1",
    "Empty",
    "Gold 1",
    "Gold 2",
    "Gold",
    "GoldEmpty",
    "Green ribbon",
    "Medal1",
    "Orange ribbon",
    "Silver",
    "Star",
    "Star1",
    "Violet ribbon"
]
