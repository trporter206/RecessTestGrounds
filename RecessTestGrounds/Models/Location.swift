//
//  Location.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import Foundation

struct Location: Identifiable, Codable {
    var id: String
    var sport: String
    var coordinates: [Double]
    var notes: String
    
    init(sport: String, coordinates: [Double], notes: String) {
        self.id = UUID().uuidString
        self.sport = sport
        self.coordinates = coordinates
        self.notes = notes
    }
}
