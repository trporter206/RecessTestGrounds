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
    var sport: String
    var maxPlayers: Int
    var playerCount: Int
    var date: Date
    var description: String
    var creator: String
    var players: [String]
    var coordinates: [Double]
    var currentlyActive: Bool
    
    init(sport: String, maxPlayers: Int, date: Date, description: String = "", coordinates: [Double], creator: String) {
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

protocol FirestoreServiceProtocol {
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void)
}

class FirestoreService: FirestoreServiceProtocol {
    func getUserInfo(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        Firestore.firestore().collection("Users").document(id).getDocument() { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
}

extension Activity {
    struct Data {
        var sport: String = sportOptions[0]
        var maxPlayers: Int = 0
        var date: Date = Date.now
        var description: String = ""
        var coordinates: [Double] = [0.0, 0.0]
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
        creator = manager.currentUser.id
        playerCount = 1
        players = [creator]
        currentlyActive = false
        points = 50
    }
}
