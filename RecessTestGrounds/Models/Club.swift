//
//  Club.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import Foundation
import SwiftUI

struct Club: Identifiable, Codable {
    var id: String
    var creator: String
    var name: String
    var sport: String
    var members: [String]
    var upcomingActivities: [String] = []
    var numActivities: Int
    var type: String
    var description: String
    
    mutating func addMember(_ user: User) {
        if !members.contains(user.id) {
            members.append(user.id)
        }
    }
    
    mutating func removeMember(_ user: User) {
        if let index = members.firstIndex(of: user.id) {
            members.remove(at: index)
        }
    }
}

extension Club {
    struct Data {
        var name: String = ""
        var sport: String = ""
        var type: String = ""
        var description: String = ""
    }
    
    var data: Data {
        Data(name: name,
             sport: sport,
             type: type,
             description: description)
    }
    
    init(data: Data, manager: TestData) {
        id = UUID().uuidString
        creator = manager.currentUser.id
        name = data.name
        sport = data.sport
        members = []
        upcomingActivities = []
        numActivities = 0
        type = data.type
        description = data.description
    }
}
