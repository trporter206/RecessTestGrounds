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
    var creator: User
    var name: String
    var sport: String
    var members: [User]
    var upcomingActivities: [Activity] = []
    var numActivities: Int
    var type: String
    var description: String
    
    mutating func addMember(_ user: User) {
        if !members.contains(user) {
                members.append(user)
            }
    }
    
    mutating func removeMember(_ user: User) {
        if let index = members.firstIndex(of: user) {
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
        creator = manager.currentUser
        name = data.name
        sport = data.sport
        members = []
        upcomingActivities = []
        numActivities = 0
        type = data.type
        description = data.description
    }
}
