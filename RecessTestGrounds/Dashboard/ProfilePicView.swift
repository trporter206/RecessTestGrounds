//
//  ProfilePicView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI
import FirebaseFirestore

struct ProfilePicView: View {
    var profileString: String
    var height: Int
    
    @State var userInfo = usersData[0]
    
    var body: some View {
        VStack {
            Image(profileString)
                .resizable()
                .scaledToFill()
                .frame(width: CGFloat(height), height: CGFloat(height))
                .clipShape(Circle())
        }
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(profileString: usersData[0].profilePicString, height: 90)
    }
}
