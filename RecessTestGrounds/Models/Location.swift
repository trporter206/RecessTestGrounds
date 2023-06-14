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
    var sport: String
    var address: String
    var coordinates: [Double]
    var notes: String
    var about: String?
    
    init(sport: String, name: String, coordinates: [Double], notes: String, address: String, about: String? = nil) {
        self.id = UUID().uuidString
        self.sport = sport
        self.coordinates = coordinates
        self.notes = notes
        self.address = address
        self.name = name
        self.about = about
    }
}
