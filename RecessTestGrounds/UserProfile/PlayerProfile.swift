//
//  PlayerProfile.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI

struct PlayerProfile: View {
    @Binding var player: User
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                MyProfileHeader(user: player)
//                ProfileClubsList(user: $player)
                ProfileFriendsList(user: player)
            }
        }
        .background(Color("LightBlue"))
    }
}

struct PlayerProfile_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProfile(player: .constant(usersData[0]))
    }
}
