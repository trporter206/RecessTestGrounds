//
//  FriendRequest.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import Foundation

struct FriendRequest: Identifiable, Equatable {
    let id = UUID()
    let sender: User
    let receiver: User
    var isAccepted: Bool = false
}
