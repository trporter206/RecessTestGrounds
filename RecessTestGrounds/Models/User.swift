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
    var followers: [String]
    var following: [String]
    var achievements: [String]
    var profilePicString: String
    var points: Int
    var numRatings: Int
    var rating: String
    var emailAddress: String
    
    init(name: String, email: String, avatar: String) {
        self.id = UUID().uuidString
        self.name = name
        self.tier = 5
        self.positiveRatingCount = 0
        self.clubs = []
        self.followers = []
        self.following = []
        self.achievements = []
        self.profilePicString = avatar
        self.points = 0
        self.numRatings = 0
        self.rating = "0.0"
        self.emailAddress = email
    }
    
    mutating func addRating(_ num: Int) {
        if num != 2 {
            self.numRatings += 1
            if num == 1 {
                self.positiveRatingCount += 1
            }
        }
    }
    
    mutating func updateRating(_ rating: Int) -> String {
        addRating(rating)
        let newRating = Double( Double(positiveRatingCount) / Double(numRatings) ) * 100
        self.rating = String(newRating)
        return String(newRating)
    }
    
    mutating func addPoints(_ points: Int) {
        self.points += points
        self.checkTier()
    }
    
    mutating func checkTier() {
        switch self.points {
        case let p where p > 800:
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
//        Firestore.firestore().collection("Users").document(self.id).updateData(["tier" : self.tier])
    }
    
    func getImage() -> Image {
        return Image(self.profilePicString)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User {
    struct Data {
        var name: String = ""
        var email: String = ""
        var profilePicString: String = ""
    }
    
    var data: Data {
        Data(name: name,
             email: emailAddress,
             profilePicString: profilePicString)
    }
    
    //profile pic???
    init(data: Data) {
        id = UUID().uuidString
        name = data.name
        emailAddress = data.email
        profilePicString = data.profilePicString
        tier = 5
        positiveRatingCount = 0
        clubs = []
        followers = []
        achievements = []
        points = 0
        following = []
        numRatings = 0
        rating = "0.0"
    }
}
