//
//  User.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import SwiftUI

struct User: Identifiable, Equatable {
    
    var id: UUID
    var name: String
    var tier: Int
    var rating: Int
    var clubs: [Club]
    var friends: [User]
    var achievements: [String]
    var profilePic: Image?
    var points: Int
    var friendRequests: [FriendRequest]
    
    init(name: String, tier: Int, rating: Int, clubs: [Club] = [], friends: [User] = [], pic: Image? = nil) {
        self.id = UUID()
        self.name = name
        self.tier = tier
        self.rating = rating
        self.clubs = clubs
        self.friends = friends
        self.achievements = []
        self.profilePic = pic
        self.points = 100
        self.friendRequests = []
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
    }
    
    func getImage() -> Image {
        guard let image = self.profilePic else {
            return Image(systemName: "person")
        }
        return image
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
