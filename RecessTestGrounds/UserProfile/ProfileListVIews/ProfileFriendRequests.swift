//
//  ProfileFriendRequests.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ProfileFriendRequests: View {
    @Binding var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Friend Requests")
                .modifier(SectionHeader())
            Text("Coming Soon!")
                .foregroundColor(Color("TextBlue"))
                .padding(.horizontal)
            ScrollView(.horizontal) {
                HStack {
                    ForEach($user.friendRequests) { $request in
                        VStack {
                            ProfilePicView(profileString: request.sender.profilePicString, height: 60)
                            Button("Accept") {
                                user.acceptRequest(request: request)
                            }
                            Button("Reject") {
                                user.rejectRequest(request: request)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ProfileFriendRequests_Previews: PreviewProvider {
    static var previews: some View {
        ProfileFriendRequests(user: .constant(usersData[0]))
    }
}
