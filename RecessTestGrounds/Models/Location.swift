//
//  Location.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import Foundation

struct Location: Identifiable, Codable {
    var id: String
    var name: String
    var sports: [String]
    var address: String
    var coordinates: [[Double]]
    var notes: [String]
    var about: String?
    var numTotalActivities: Int
    var currentActivities: [String]
    var activeClubs: [String]
    
    init(sports: [String], name: String, coordinates: [[Double]], notes: [String], address: String, about: String? = nil) {
        self.id = UUID().uuidString
        self.sports = sports
        self.coordinates = coordinates
        self.notes = notes
        self.address = address
        self.name = name
        self.about = about
        self.numTotalActivities = 0
        self.currentActivities = []
        self.activeClubs = []
    }
    
    mutating func addActivity(_ activity: Activity) {
        if !currentActivities.contains(activity.id) {
            currentActivities.append(activity.id)
        }
    }
    
    mutating func removeActivity(_ activity: Activity) {
        if let index = currentActivities.firstIndex(of: activity.id) {
            currentActivities.remove(at: index)
        }
    }
    
    mutating func addClub(_ club: Club) {
        if !activeClubs.contains(club.id) {
            activeClubs.append(club.id)
        }
    }
    
    mutating func removeClub(_ club: Club) {
        if let index = activeClubs.firstIndex(of: club.id) {
            activeClubs.remove(at: index)
        }
    }
}
