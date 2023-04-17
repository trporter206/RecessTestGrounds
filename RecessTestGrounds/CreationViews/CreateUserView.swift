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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding()
            SuperTextField(placeholder: Text("   Name").foregroundColor(.white),
                           text: $userData.name)
            .modifier(FormField())
            SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                           text: $userData.email)
            .modifier(FormField())
            SuperTextField(placeholder: Text("   Password").foregroundColor(.white),
                           text: $password)
            .modifier(FormField())
            Spacer()
            Text(errorMessage).foregroundColor(.orange)
            Spacer()
            Button(action: {
                let user = User(data: userData)
                Task {
                    await signUp(user: user)
                }
                tD.loggedIn = true
                self.presentationMode.wrappedValue.dismiss()
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
    func createUser(user: User) {
        let id = UUID().uuidString
        Firestore.firestore().collection("Users").document(id).setData([
            "id" : id,
            "name" : user.name,
            "tier" : user.tier,
            "positiveRatingCount" : user.positiveRatingCount,
            "clubs" : user.clubs,
            "friends" : user.friends,
            "achievements" : user.achievements,
            "points" : user.points,
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
