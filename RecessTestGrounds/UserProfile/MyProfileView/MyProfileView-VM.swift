//
//  MyProfileView-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-10.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct UserCard: View {
    @Binding var user: User
    
    var body: some View {
        VStack {
            ProfilePicView(profileString: user.profilePicString, height: 60)
            Text(Array(user.name.split(separator: " "))[0]).foregroundColor(Color("TextBlue"))
            Text("\(user.points)").bold()
        }
        .foregroundColor(.orange)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
        )
        .padding(.leading)
    }
}

struct FollowerList: View {
    @Binding var user: User
    @Binding var followers: [User]
    
    var body: some View {
        VStack {
            Text("Followers: \(user.followers.count)")
                .modifier(SectionHeader())
            ScrollView(.horizontal) {
                ForEach($followers) { follower in
                    UserCard(user: follower)
                }
            }
        }
    }
}

struct FollowingList: View {
    @Binding var user: User
    @Binding var followings: [User]
    
    var body: some View {
        VStack {
            Text("Following: \(user.following.count)")
                .modifier(SectionHeader())
            ScrollView(.horizontal) {
                ForEach($followings) { following in
                    UserCard(user: following)
                }
            }
        }
    }
}

struct LogOutButton: View {
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        Button(action: {
            do {
                try Auth.auth().signOut()
                tD.loggedIn = false
            } catch {
                print("Error signing out: \(error)")
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.orange)
                    .frame(width: 300, height: 60)
                Text("Log Out")
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
        })
    }
}

struct EditProfileButton: View {
    @EnvironmentObject var tD: TestData
    
    var body: some View {
        NavigationLink(destination: CreateUserView().environmentObject(tD), label: {
            Text("Edit Profile")
        })
    }
}

struct DeleteProfileButton: View {
    @Binding var deleteAccount: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            deleteAccount.toggle()
        } label: {
            Text("Delete profile")
                .foregroundColor(.red)
                .padding()
        }
        .alert(isPresented: $deleteAccount) {
            Alert(title: Text("Delete user data?"),
                  message: Text("Your info will be deleted and you will be returned to login"),
                  primaryButton: .default(
                  Text("Cancel"),
                  action: {deleteAccount.toggle()}
                  ),
                  secondaryButton: .destructive(
                  Text("Delete"),
                  action: action
                  )
            )
        }
    }
}

extension MyProfileView {
    func deleteAccountInfo() {
        Auth.auth().currentUser!.delete { error in
            if let error = error {
                print("There was an error deleting your account: \(error)")
            }
        }
        FirestoreService.shared.deleteUser(user)
        tD.loggedIn = false
        print("Account Deleted")
    }
}
