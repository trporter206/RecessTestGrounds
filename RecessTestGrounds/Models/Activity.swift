//
//  Activity.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct Activity: Identifiable, Codable {
    var id: String
    var points: Int
    var title: String
    var sport: String
    var playerCount: Int
    var date: Date
    var description: String
    var creator: String
    var players: [String]
    var coordinates: [Double]
    var currentlyActive: Bool
    
    init(title: String, sport: String, date: Date, description: String = "", coordinates: [Double], creator: String) {
        self.id = UUID().uuidString
        self.title = title
        self.sport = sport
        self.date = date
        self.description = description
        self.coordinates = coordinates
        self.creator = creator
        self.playerCount = 1
        self.players = [creator]
        self.currentlyActive = false
        self.points = 50
    }
    
    mutating func addPlayer(_ user: User) {
        if !players.contains(user.id) {
            players.append(user.id)
            playerCount += 1
        }
    }
    
    mutating func removePlayer(_ user: User) {
        if let index = players.firstIndex(of: user.id) {
            players.remove(at: index)
            playerCount -= 1
        }
    }
}

extension Activity {
    struct Data {
        var title: String = ""
        var sport: String = sportOptions[0]
        var date: Date = Date.now
        var description: String = ""
        var coordinates: [Double] = [0.0, 0.0]
    }
    
    var data: Data {
        Data(
            title: title,
            sport: sport,
            date: date,
            description: description,
            coordinates: coordinates)
    }
    
    init(data: Data, manager: TestData) {
        id = UUID().uuidString
        title = data.title
        sport = data.sport
        date = data.date
        description = data.description
        coordinates = data.coordinates
        creator = manager.currentUser.id
        playerCount = 1
        players = [creator]
        currentlyActive = false
        points = 50
    }
}
