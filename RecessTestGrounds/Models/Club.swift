//
//  Club.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import Foundation
import SwiftUI

struct Club: Identifiable {
    var id: UUID
    var creator: User
    var name: String
    var sport: String
    var members: [User]
    var upcomingActivities: [Activity] = []
    var numActivities: Int
    var type: String
    var description: String
    var coverPhoto: Image?
    
    func getImage() -> Image {
        guard let image = self.coverPhoto else {
            return Image(systemName: "person.3.fill")
        }
        return image
    }
    
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
