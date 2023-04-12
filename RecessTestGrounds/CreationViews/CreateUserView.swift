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

struct CreateUserView: View {
    @EnvironmentObject var tD: TestData
    @State var userData = User.Data()
    @State var showingAlert = false
    @State var password = ""
    
    var body: some View {
        VStack {
            Text("Create New Profile")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding()
            SuperTextField(placeholder: Text("   Name").foregroundColor(.white),
                         text: $userData.name)
                .modifier(FormField())
            SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                         text: $userData.email)
                .modifier(FormField())
            Spacer()
            NavigationLink(destination: DashboardView(), label: {
                Button(action: {
                    let user = User(data: userData)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.orange)
                            .frame(width: 300, height: 60)
                        Text("Create User")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                })
            })
        }
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
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
