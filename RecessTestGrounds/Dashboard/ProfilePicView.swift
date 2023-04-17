//
//  ProfilePicView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI
import FirebaseFirestore

struct ProfilePicView: View {
    var user: String
    var height: Int
    
    @State var userInfo = usersData[0]
    
    var body: some View {
        VStack {
            userInfo
                .getImage()
                .resizable()
                .scaledToFill()
                .frame(width: CGFloat(height), height: CGFloat(height))
                .clipShape(Circle())
        }
        .onAppear {
            getUserInfo()
        }
    }
}

extension ProfilePicView {
    func getUserInfo() {
        Firestore.firestore().collection("Users").document(user).getDocument() { documentSnapshot, error in
            if let error = error {
                print("Error getting profile pic info \(error)")
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    userInfo = user
                } catch {
                    print("Error decoding profile pic info \(error)")
                }
            }
        }
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(user: usersData[0].id, height: 90)
    }
}
