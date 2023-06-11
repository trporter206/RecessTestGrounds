//
//  MyProfileView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore
//import FirebaseStorage

struct MyProfileView: View {
    @EnvironmentObject var tD: TestData
    @Binding var user: User
    @State private var deleteAccount = false
    @State private var followers: [User] = []
    @State private var following: [User] = []
//    @State private var image = Image(systemName: "camera")
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                MyProfileHeader(user: user)
                //CameraView(onCapture: { capturedImage in
                //  user.profilePic = Image(uiImage: capturedImage)
                //})
                //.padding()
//                ProfileClubsList(user: $user)
                FollowerList(user: $user, followers: $followers)
                FollowingList(user: $user, followings: $following)
                LogOutButton()
                HStack {
                    EditProfileButton()
                    DeleteProfileButton(deleteAccount: $deleteAccount, action: deleteAccountInfo)
                }.padding([.horizontal, .bottom])
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            for id in user.followers {
                FirestoreService.shared.getUserInfo(id: id) {result in
                    switch result {
                    case .success(let user):
                        followers.append(user)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            for id in user.following {
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
