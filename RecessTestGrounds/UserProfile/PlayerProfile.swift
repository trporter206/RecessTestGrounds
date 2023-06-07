//
//  PlayerProfile.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI

struct PlayerProfile: View {
    @EnvironmentObject var tD: TestData
    @Binding var player: User
    @State private var followers: [User] = []
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                MyProfileHeader(user: player)
                FollowButton(player: $player, followers: $followers).environmentObject(tD)
                Text("Followers \($followers.count)")
                ForEach($followers) { follower in
                    ProfilePicView(profileString: follower.wrappedValue.profilePicString, height: 60)
                }
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            for id in player.followers {
                FirestoreService.shared.getUserInfo(id: id) {result in
                    switch result {
                    case .success(let user):
                        followers.append(user)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

struct PlayerProfile_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProfile(player: .constant(usersData[0]))
    }
}

struct FollowButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var player: User
    @Binding var followers: [User]
    
    var body: some View {
        if player.id != tD.currentUser.id {
            if !tD.currentUser.following.contains(player.id) {
                Button(action: {
                    followers.append(tD.currentUser)
                    player.addFollower(tD.currentUser.id)
                    tD.currentUser.addFollowing(player.id)
                    FirestoreService.shared.addFollowing(user: tD.currentUser, id: player.id)
                    FirestoreService.shared.addFollower(user: player, id: tD.currentUser.id)
                }, label: {
                    ActivityButton("Follow")
                })
            } else {
                Button(action: {
                    followers.removeAll(where: {$0.id == tD.currentUser.id})
                    player.removeFollower(tD.currentUser.id)
                    tD.currentUser.removeFollowing(player.id)
                    FirestoreService.shared.removeFollowing(user: tD.currentUser, id: player.id)
                    FirestoreService.shared.removeFollower(user: player, id: tD.currentUser.id)
                }, label: {
                    ActivityButton("Unfollow")
                })
            }
        }
    }
}
