//
//  Activity.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import Foundation

struct Activity: Identifiable {
    var id: UUID
    var sport: String
    var maxPlayers: Int
    var playerCount: Int
    var locationName: String
    var date: String
    var description: String
    var creator: User
    var players: [User]
    var coordinates: [Double]
    var currentlyActive: Bool = false
    
    mutating func addPlayer(_ user: User) {
        if !players.contains(user) {
                players.append(user)
            }
    }
    
    mutating func removePlayer(_ user: User) {
        if let index = players.firstIndex(of: user) {
            players.remove(at: index)
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
    
    func getLocationName() -> String {
        return self.locationName
    }
    
    func getDate() -> String {
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
