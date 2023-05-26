//
//  CreateUserView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-11.
//

import SwiftUI
import FirebaseAuth

struct CreateUserView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @State var userData = User.Data()
    @State var showingAlert = false
    @State var password = ""
    @State var confirmedPassword = ""
    @State var errorMessage = ""
    @State var chosenAvatar = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                CreateProfileHeader()
                CreateUserFields(userData: $userData,
                                 password: $password,
                                 confirmedPassword: $confirmedPassword,
                                 chosenAvatar: $chosenAvatar).environmentObject(tD)
                .padding()
                Spacer()
                ErrorMessageText(errorMessage: $errorMessage)
                Spacer()
                if tD.loggedIn {
                    UpdateProfileButton(user: $userData, chosenAvatar: $chosenAvatar)
                } else {
                    SignUpProfileButton(userData: $userData,
                                        errorMessage: $errorMessage,
                                        chosenAvatar: $chosenAvatar,
                                        password: $password,
                                        confirmedPassword: $confirmedPassword,
                                        showingAlert: $showingAlert)
                }
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            if tD.loggedIn {
                userData = tD.currentUser.data
                chosenAvatar = tD.currentUser.profilePicString
            }
        }
    }
}

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
//            let updateUser = tD.currentUser
            self.presentationMode.wrappedValue.dismiss()
//            tD.currentUser = updateUser
        }, label: {
            ZStack {
                ActivityButton("Update Profile")
            }
            .padding()
        })
    }
}

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

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
