//
//  Activity.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation

struct Activity: Identifiable {
    var id: String
    let points = 50
    var sport: String
    var maxPlayers: Int
    var playerCount: Int
    var date: Date
    var description: String
    var creator: User
    var players: [User]
    var coordinates: [Double]
    var currentlyActive: Bool
    
    init(sport: String, maxPlayers: Int, date: Date, description: String = "", coordinates: [Double], creator: User) {
        self.id = UUID().uuidString
        self.sport = sport
        self.maxPlayers = maxPlayers
        self.date = date
        self.description = description
        self.coordinates = coordinates
        self.creator = creator
        self.playerCount = 1
        self.players = [creator]
        self.currentlyActive = false
    }
    
    mutating func addPlayer(_ user: User) {
        if !players.contains(user) {
            players.append(user)
            playerCount += 1
        }
    }
    
    mutating func removePlayer(_ user: User) {
        if let index = players.firstIndex(of: user) {
            players.remove(at: index)
            playerCount -= 1
        }
    }
    
    //GETTERS==============================
    
    func getSport() -> String {
        return self.sport
    }
    
    func getMaxPlayers() -> Int {
        return self.maxPlayers
    }
    
    func getPlayerCount() -> Int {
        return self.playerCount
    }
    
    func getDate() -> Date {
        return self.date
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getCreator() -> User {
        return self.creator
    }
    
    func getPlayers() -> [User] {
        return self.players
    }
}

extension Activity {
    struct Data {
        var sport: String = ""
        var maxPlayers: Int = 0
        var date: Date = Date.now
        var description: String = ""
        var coordinates: [Double] = []
    }
    
    var data: Data {
        Data(sport: sport,
        maxPlayers: maxPlayers,
        date: date,
        description: description,
        coordinates: coordinates)
    }
    
    init(data: Data, manager: TestData) {
        id = UUID().uuidString
        sport = data.sport
        maxPlayers = data.maxPlayers
        date = data.date
        description = data.description
        coordinates = data.coordinates
        creator = manager.currentUser
        playerCount = 1
        players = [creator]
        currentlyActive = false
    }
}
