//
//  TestData.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI

var usersData: [User] = [
    User(name: "Torri Porter",
         tier: 2,
         rating: 97,
         pic: Image(systemName: "person")),
    User(name: "Alison Parker",
         tier: 3,
         rating: 97,
         pic: Image(systemName: "person")),
    User(name: "Nikki Layson",
         tier: 4,
         rating: 97,
         pic: Image(systemName: "person")),
    User(name: "Indigo Ward",
         tier: 5,
         rating: 97,
         pic: Image(systemName: "person")),
    User(name: "Lauren Verdile",
         tier: 1,
         rating: 97,
         pic: Image(systemName: "person")),
    User(name: "Jackie Smith",
         tier: 2,
         rating: 97,
         pic: Image(systemName: "person"))
]

var activitiesData: [Activity] = [
    Activity(id: UUID(), sport: "Basketball",
             maxPlayers: 5,
             playerCount: 5,
             locationName: "Portland Park",
             date: "3/7",
             description: "Casual game downtown. Come join the crew!",
             creator: usersData[0],
             players: Array(usersData[1...4]),
             coordinates: [45.568978, -122.673523]),
    Activity(id: UUID(), sport: "Pickleball",
             maxPlayers: 4,
             playerCount: 4,
             locationName: "",
             date: "3/8",
             description: "",
             creator: usersData[1],
             players: Array(usersData[1...3]),
             coordinates: [45.572117, -122.653938]),
    Activity(id: UUID(), sport: "Soccer",
             maxPlayers: 8,
             playerCount: 5,
             locationName: "",
             date: "3/10",
             description: "",
             creator: usersData[2],
             players: Array(usersData[3...5]),
             coordinates: [45.564605, -122.644914]),
    Activity(id: UUID(), sport: "Basketball",
             maxPlayers: 4,
             playerCount: 2,
             locationName: "",
             date: "3/11",
             description: "",
             creator: usersData[3],
             players: Array(usersData[0...1]),
             coordinates: [45.559431, -122.671676]),
    Activity(id: UUID(), sport: "Tennis",
             maxPlayers: 4,
             playerCount: 2,
             locationName: "",
             date: "3/18",
             description: "",
             creator: usersData[4],
             players: Array(usersData[0...3]),
             coordinates: [45.551678, -122.670534])
]

var clubsData: [Club] = [
    Club(id: UUID(),
         creator: usersData[0],
         name: "Portland Blacktop",
         sport: "Basketball",
         members: usersData,
         numActivities: 12,
         type: "Paid",
         description: "For Portlanders who are serious weekend warriors looking to improve their game"),
    Club(id: UUID(),
         creator: usersData[1],
         name: "Pickle Rick Lovers United Club",
         sport: "Pickleball",
         members: usersData,
         numActivities: 15,
         type: "Competitive",
         description: "description"),
    Club(id: UUID(),
         creator: usersData[2],
         name: "Slammin Soccer",
         sport: "Soccer",
         members: usersData,
         numActivities: 8,
         type: "Open",
         description: "description"),
    Club(id: UUID(),
         creator: usersData[3],
         name: "Ultimate Newbies",
         sport: "Ultimate Frisbee",
         members: usersData,
         numActivities: 20,
         type: "Competitive",
         description: "description"),
    Club(id: UUID(),
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

class TestData: ObservableObject {
    @Published var users = usersData
    @Published var clubs = clubsData
    @Published var activities = activitiesData
    @Published var currentUser = usersData[0]
    
    init() {
        currentUser.friendRequests.append(FriendRequest(sender: usersData[1], receiver: currentUser))
    }
}
