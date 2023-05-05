//
//  PlayerProfile.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI

struct PlayerProfile: View {
    var tD: TestData
    @Binding var player: User
    @State var isFriend: Bool = false
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
        PlayerProfile(tD: TestData(), player: .constant(usersData[0]))
    }
}
