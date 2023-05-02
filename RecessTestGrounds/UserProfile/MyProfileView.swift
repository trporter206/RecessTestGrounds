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
//    @State private var image = Image(systemName: "camera")
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                MyProfileHeader(user: user)
                //CameraView(onCapture: { capturedImage in
                //  user.profilePic = Image(uiImage: capturedImage)
                //})
                //.padding()
                ProfileClubsList(user: $user)
                Text("Coming Soon!")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.horizontal)
                ProfileFriendsList(user: user)
                Text("Coming Soon!")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.horizontal)
                ProfileFriendRequests(user: $user)
                Text("Coming Soon!")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.horizontal)
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
        .background(Color("LightBlue"))
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView(user: .constant(usersData[0])).environmentObject(TestData())
    }
}
