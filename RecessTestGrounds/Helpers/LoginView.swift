//
//  LoginView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-12.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                           text: $email)
            .modifier(FormField())
            SuperTextField(placeholder: Text("   Password").foregroundColor(.white),
                           text: $password)
            .modifier(FormField())
            Spacer()
            Text(errorMessage).foregroundColor(.orange)
            Spacer()
            Button(action: {
                login()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.orange)
                        .frame(width: 300, height: 60)
                    Text("Login")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
            })
            NavigationLink(destination: CreateUserView().environmentObject(tD), label: {
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

extension LoginView {
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                errorMessage = "Error reaching data: \(error!)"
            } else {
                Firestore.firestore().collection("Users").whereField("emailAddress", isEqualTo: email).getDocuments() { documentSnapshot, error in
                    if let error = error {
                        errorMessage = "Error getting user info: \(error)"
                    } else {
                        do {
                            for document in documentSnapshot!.documents {
                                tD.currentUser = try document.data(as: User.self)
                                print("Current user is \(tD.currentUser.name)")
                            }
                        } catch {
                            errorMessage = "Error decoding info: \(error)"
                        }
                    }
                }
                tD.loggedIn = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(TestData())
    }
}
