//
//  CreateUserView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-11.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct CreateUserView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @State var userData = User.Data()
    @State var showingAlert = false
    @State var password = ""
    @State var errorMessage = ""
    @State var chosenAvatar = ""
    @Environment(\.presentationMode) var presentationMode
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding([.top, .horizontal])
            Text("Enter details to create yor player profile")
                .font(.title2)
                .foregroundColor(Color("TextBlue"))
                .padding(.bottom)
            CreateUserFields(userData: $userData, password: $password, chosenAvatar: $chosenAvatar)
            .padding()
            Spacer()
            Text(errorMessage)
                .bold()
                .foregroundColor(.orange)
            Spacer()
            Button(action: {
                if isValidEmail(userData.email) && noBlankFields() {
                    var user = User(data: userData)
                    user.profilePicString = chosenAvatar
                    Task {
                        await signUp(user: user)
                    }
                    tD.loggedIn = true
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    errorMessage = "Make sure email format is correct and all fields are filled"
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 60)
                    Text("Sign Up")
                        .foregroundColor(.orange)
                        .bold()
                }
                .padding()
            })
        }
        .background(Color("LightBlue"))
    }
}

extension CreateUserView {
    func noBlankFields() -> Bool {
        if userData.name != "" && password != "" && chosenAvatar != "" {
            return true
        }
        return false
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
    
    func createUser(user: User) {
        Firestore.firestore().collection("Users").document(user.id).setData([
            "id" : user.id,
            "name" : user.name,
            "tier" : user.tier,
            "positiveRatingCount" : user.positiveRatingCount,
            "clubs" : user.clubs,
            "friends" : user.friends,
            "achievements" : user.achievements,
            "points" : user.points,
            "profilePicString" : chosenAvatar,
            "friendRequests" : user.friendRequests,
            "numRatings" : user.numRatings,
            "rating" : user.rating,
            "emailAddress" : user.emailAddress
        ])
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

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
