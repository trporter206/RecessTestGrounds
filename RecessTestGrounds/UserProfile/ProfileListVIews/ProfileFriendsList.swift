//
//  ProfileFriendsList.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ProfileFriendsList: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friends List")
                .modifier(SectionHeader())
            Text("Coming Soon!")
                .foregroundColor(Color("TextBlue"))
                .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(user.friends, id: \.self) { friend in
                        VStack {
//                            ProfilePicView(profileString: friend.profilePicString, height: 90)
                            Text(friend)
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
        ProfileFriendsList(user: usersData[0])
    }
}
