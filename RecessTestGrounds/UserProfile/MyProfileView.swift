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
                
                LogOutButton()
                HStack {
                    EditProfileButton()
                    DeleteProfileButton(deleteAccount: $deleteAccount, action: deleteAccountInfo)
                }.padding([.horizontal, .bottom])
            }
        }
        .background(Color("LightBlue"))
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

//struct MyProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyProfileView(user: .constant(usersData[0])).environmentObject(TestData())
//    }
//}
