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
        
    }
    
    func getActivities() {
        activities = []
        Firestore.firestore().collection("Activities").getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let activity = try document.data(as: Activity.self)
                        self.activities.append(activity)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}




var usersData: [User] = [
    User(name: "Torri Porter", email: "test@email.com"),
    User(name: "Alison Parker", email: "test@email.com"),
    User(name: "Nikki Layson", email: "test@email.com"),
    User(name: "Indigo Ward", email: "test@email.com"),
    User(name: "Lauren Verdile", email: "test@email.com"),
    User(name: "Jackie Smith", email: "test@email.com"),
]

var activitiesData: [Activity] = [
    Activity(sport: "Basketball",
             maxPlayers: 5,
             date: Date.now,
             description: "Casual game downtown. Come join the crew!",
             coordinates: [45.568978, -122.673523],
             creator: usersData[0]),
    Activity(sport: "Pickleball",
             maxPlayers: 4,
             date: Date.now,
             description: "",
             coordinates: [45.572117, -122.653938],
             creator: usersData[1]),
    Activity(sport: "Soccer",
             maxPlayers: 8,
             date: Date.now,
             description: "",
             coordinates: [45.564605, -122.644914],
             creator: usersData[2]),
    Activity(sport: "Basketball",
             maxPlayers: 4,
             date: Date.now,
             description: "",
             coordinates: [45.559431, -122.671676],
             creator: usersData[3]),
    Activity(sport: "Tennis",
             maxPlayers: 4,
             date: Date.now,
             description: "",
             coordinates: [45.551678, -122.670534],
             creator: usersData[4])
]

var clubsData: [Club] = [
    Club(id: UUID().uuidString,
         creator: usersData[0],
         name: "Portland Blacktop",
         sport: "Basketball",
         members: usersData,
         numActivities: 12,
         type: "Paid",
         description: "For Portlanders who are serious weekend warriors looking to improve their game"),
    Club(id: UUID().uuidString,
         creator: usersData[1],
         name: "Pickle Rick Lovers United Club",
         sport: "Pickleball",
         members: usersData,
         numActivities: 15,
         type: "Competitive",
         description: "description"),
    Club(id: UUID().uuidString,
         creator: usersData[2],
         name: "Slammin Soccer",
         sport: "Soccer",
         members: usersData,
         numActivities: 8,
         type: "Open",
         description: "description"),
    Club(id: UUID().uuidString,
         creator: usersData[3],
         name: "Ultimate Newbies",
         sport: "Ultimate Frisbee",
         members: usersData,
         numActivities: 20,
         type: "Competitive",
         description: "description"),
    Club(id: UUID().uuidString,
         creator: usersData[4],
         name: "Vigorous Volley",
         sport: "Volleyball",
         members: usersData,
         numActivities: 13,
         type: "Competitive",
         description: "description"),
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
