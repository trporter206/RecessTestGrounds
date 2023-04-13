//
//  FriendRequest.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import Foundation

struct FriendRequest: Identifiable, Equatable, Codable {
    var id = UUID().uuidString
    var sender: User
    var receiver: User
    var isAccepted: Bool = false
}
