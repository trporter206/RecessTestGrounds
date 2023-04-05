//
//  ProfileFriendsList.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ProfileFriendsList: View {
    @Binding var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Friends")
                .modifier(SectionHeader())
            ScrollView(.horizontal) {
                HStack {
                    ForEach($user.friends) { $friend in
                        VStack {
                            ProfilePicView(user: $friend, height: 90)
                            Text(friend.name)
                        }
                        .padding(.leading)
                    }
                }
            }
        }
    }
}

struct ProfileFriendsList_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFriendsList(user: .constant(usersData[0]))
    }
}
