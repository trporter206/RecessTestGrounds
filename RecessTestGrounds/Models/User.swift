//
//  User.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI
import FirebaseFirestore

struct User: Identifiable, Equatable, Codable {
    
    var id: String
    var name: String
    var tier: Int
    var positiveRatingCount: Int
    var clubs: [Club]
    var friends: [User]
    var achievements: [String]
//    var profilePic: Image? = nil
    var points: Int
    var friendRequests: [FriendRequest]
    var numRatings: Int
    var rating: Double
    var emailAddress: String
    
    init(name: String, email: String) {
        self.id = UUID().uuidString
        self.name = name
        self.tier = 5
        self.positiveRatingCount = 0
        self.clubs = []
        self.friends = []
        self.achievements = []
//        self.profilePic = nil
        self.points = 0
        self.friendRequests = []
        self.numRatings = 0
        self.rating = 0.0
        self.emailAddress = email
    }
    
    mutating func addRating(_ num: Int) {
        self.numRatings += 1
        if num == 1 {
            self.positiveRatingCount += 1
        }
    }
    
    mutating func updateRating(_ rating: Int) {
        addRating(rating)
        self.rating = Double(positiveRatingCount / numRatings)
    }
    
    mutating func checkTier() {
        switch points {
        case let p where p > 750:
            self.tier = 1
        case let p where p > 500:
            self.tier = 2
        case let p where p > 250:
            self.tier = 3
        case let p where p > 100:
            self.tier = 4
        default:
            self.tier = 5
        }
    }
    
    mutating func acceptRequest(request: FriendRequest) {
        guard let index = friendRequests.firstIndex(of: request) else { return }
        friendRequests[index].isAccepted = true
        friends.append(request.sender)
        //TODO: add reciever to senders friend list as well
        friendRequests.remove(at: index)
    }
    
    mutating func rejectRequest(request: FriendRequest) {
        guard let index = friendRequests.firstIndex(of: request) else { return }
        friendRequests.remove(at: index)
    }
    
    mutating func addPoints(_ points: Int) {
        self.points += points
        self.checkTier()
    }
    
    func getImage() -> Image {
        return Image(systemName: "person")
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getTier() -> Int {
        return self.tier
    }
    
    func getInitials() -> String {
        var initials = ""
        for word in self.getName().components(separatedBy: " ") {
            initials.append(word.capitalized.first!)
        }
        return initials
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User {
    struct Data {
        var name: String = ""
        var email: String = ""
    }
    
    var data: Data {
        Data(name: name,
             email: emailAddress)
    }
    
    //profile pic???
    init(data: Data) {
        id = UUID().uuidString
        name = data.name
        emailAddress = data.email
        tier = 5
        positiveRatingCount = 0
        clubs = []
        friends = []
        achievements = []
        points = 0
        friendRequests = []
        numRatings = 0
        rating = 0.0
    }
}
