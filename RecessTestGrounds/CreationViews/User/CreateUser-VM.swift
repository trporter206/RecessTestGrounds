//
//  CreateUser-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-28.
//

import Foundation
import FirebaseAuth
import SwiftUI

extension CreateUserView {
    @MainActor class ViewModel: ObservableObject {
        @Published var userData = User.Data()
        @Published var showingAlert = false
        @Published var password = ""
        @Published var confirmedPassword = ""
        @Published var errorMessage = ""
        @Published var chosenAvatar = ""
    }
}

//Views: CreateUserView
//Env: tD.loggedIn = true
//Func: User clicks this button to save updated profile data
//Navigation: dismiss to MyProfile
struct UpdateProfileButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var user: User.Data
    @Binding var chosenAvatar: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            FirestoreService.shared.updateUser(data: user, chosenAvatar: chosenAvatar, id: tD.currentUser.id)
            tD.currentUser.name = user.name
            tD.currentUser.profilePicString = chosenAvatar
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            ZStack {
                ActivityButton("Update Profile")
            }
            .padding()
        })
    }
}

//Views: CreateUserView
//Env: tD.loggedIn = false
//Func: Create new profile, add data to firebase, log in
//Navigation: dismiss to dashboard
struct SignUpProfileButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var userData: User.Data
    @Binding var errorMessage: String
    @Binding var chosenAvatar: String
    @Binding var password: String
    @Binding var confirmedPassword: String
    @Binding var showingAlert: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            if isValidEmail(userData.email) && verifyFields() {
                var user = User(data: userData)
                user.profilePicString = chosenAvatar
                Task {
                    await signUp(user: user)
                }
                tD.loggedIn = true
                self.presentationMode.wrappedValue.dismiss()
            }
        }, label: {
            ActivityButton("Sign Up")
        })
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        do {
            let regex = try NSRegularExpression(pattern: emailRegexPattern)
            let range = NSRange(location: 0, length: email.utf16.count)
            return regex.firstMatch(in: email, options: [], range: range) != nil
        } catch {
            print(error)
            return false
        }
    }

    func verifyFields() -> Bool {
        if userData.name == "" || password == "" && chosenAvatar == "" {
            errorMessage = "Incomplete fields"
            return false
        }
        if password != confirmedPassword {
            errorMessage = "Passwords do not match"
            return false
        }
        return true
    }

    func createUser(user: User) {
        FirestoreService.shared.createUser(user: user, avatar: chosenAvatar)
        showingAlert = true
        tD.currentUser = user
    }

    func signUp(user: User) async {
        do {
            let _ = try await Auth.auth().createUser(withEmail: user.emailAddress,
                                                     password: password)
            createUser(user: user)
        } catch {
            print("Error in signup: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}

//View: CreateUserView
//Func: Display page title and note
struct CreateProfileHeader: View {
    var body: some View {
        Text("Profile")
            .font(.largeTitle)
            .foregroundColor(Color("TextBlue"))
            .padding([.top, .horizontal])
        Text("Enter details to create yor player profile")
            .font(.title2)
            .foregroundColor(Color("TextBlue"))
            .padding(.bottom)
    }
}

//View: CreateUserView
//Func: display the necessary input fields for new user
struct CreateUserFields: View {
    @EnvironmentObject var tD: TestData
    @Binding var userData: User.Data
    @Binding var password: String
    @Binding var confirmedPassword: String
    @Binding var chosenAvatar: String
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Name").foregroundColor(.white),
                           text: $userData.name)
            .modifier(FormField())
            if !tD.loggedIn {
                SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                               text: $userData.email)
                .modifier(FormField())
                SuperTextField(placeholder: Text("   Password").foregroundColor(.white),
                               text: $password)
                .modifier(FormField())
                SuperTextField(placeholder: Text("   Confirm Password").foregroundColor(.white),
                               text: $confirmedPassword)
                .modifier(FormField())
            }
            Text("Choose an Avatar")
                .modifier(SectionHeader())
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0...avatarStrings.count-1, id: \.self) { index in
                    if chosenAvatar == avatarStrings[index] {
                        ChosenAvatarView(chosenAvatar: $chosenAvatar,
                                         index: index,
                                         avatarStrings: avatarStrings)
                    } else {
                        BlurredAvatarView(chosenAvatar: $chosenAvatar,
                                          index: index,
                                          avatarStrings: avatarStrings)
                    }
                }
            }
            .padding()
        }
    }
}

//View: CreateUserView
//Func: Highlight the avatar currently chosen by the user
struct ChosenAvatarView: View {
    @Binding var chosenAvatar: String
    var index: Int
    var avatarStrings: [String]
    
    var body: some View {
        Button(action: {
            chosenAvatar = avatarStrings[index]
        }, label: {
            ZStack(alignment: .center) {
                Image(avatarStrings[index])
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(90), height: CGFloat(90))
                    .clipShape(Circle())
            }
        })
    }
}

//View: CreateUserView
//Func: Partially hide avatars not chosen by user
struct BlurredAvatarView: View {
    @Binding var chosenAvatar: String
    var index: Int
    var avatarStrings: [String]
    
    var body: some View {
        Button(action: {
            chosenAvatar = avatarStrings[index]
        }, label: {
            ZStack(alignment: .center) {
                Image(avatarStrings[index])
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .frame(width: CGFloat(90), height: CGFloat(90))
                    .clipShape(Circle())
            }
        })
    }
}

