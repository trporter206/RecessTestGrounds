//
//  TestData.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI

class TestData: ObservableObject {
    @Published var users = usersData
    @Published var clubs = clubsData
    @Published var activities = activitiesData
    @Published var currentUser = usersData[0]
    
    init() {
        currentUser.friendRequests.append(FriendRequest(sender: usersData[1], receiver: currentUser))
        activities[0].addPlayer(users[1])
        activities[0].addPlayer(users[2])
        activities[0].addPlayer(users[3])
        activities[0].addPlayer(users[4])
    }
}




var usersData: [User] = [
    User(name: "Torri Porter"),
    User(name: "Alison Parker"),
    User(name: "Nikki Layson"),
    User(name: "Indigo Ward"),
    User(name: "Lauren Verdile"),
    User(name: "Jackie Smith"),
]

var activitiesData: [Activity] = [
    Activity(sport: "Basketball",
             maxPlayers: 5,
             date: "3/7",
             description: "Casual game downtown. Come join the crew!",
             coordinates: [45.568978, -122.673523],
             creator: usersData[0]),
    Activity(sport: "Pickleball",
             maxPlayers: 4,
             date: "3/8",
             description: "",
             coordinates: [45.572117, -122.653938],
             creator: usersData[1]),
    Activity(sport: "Soccer",
             maxPlayers: 8,
             date: "3/10",
             description: "",
             coordinates: [45.564605, -122.644914],
             creator: usersData[2]),
    Activity(sport: "Basketball",
             maxPlayers: 4,
             date: "3/11",
             description: "",
             coordinates: [45.559431, -122.671676],
             creator: usersData[3]),
    Activity(sport: "Tennis",
             maxPlayers: 4,
             date: "3/18",
             description: "",
             coordinates: [45.551678, -122.670534],
             creator: usersData[4])
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
