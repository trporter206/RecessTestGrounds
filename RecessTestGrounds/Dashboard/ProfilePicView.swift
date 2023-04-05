//
//  ProfilePicView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct ProfilePicView: View {
    @Binding var user: User
    var height: Int
    
    var body: some View {
        NavigationLink(destination: MyProfileView(user: $user), label: {
                user.getImage()
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(height), height: CGFloat(height))
                    .clipShape(Circle())
        })
    }
}

extension ProfilePicView {
    @ViewBuilder
    func userImage(_ user: User,_ height: Int) -> some View {
        user.getImage()
            .resizable()
            .scaledToFill()
            .frame(width: CGFloat(height), height: CGFloat(height))
            .clipShape(Circle())
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(user: .constant(usersData[0]), height: 90)
    }
}
