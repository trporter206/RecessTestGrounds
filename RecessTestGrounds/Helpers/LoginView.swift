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
            Heading()
            EmailTextField(email: $email)
            PasswordTextField(password: $password)
            ForgotPasswordLink()
            Spacer()
            ErrorMessageText(errorMessage: $errorMessage)
            Spacer()
            LoginButton(action: login)
            SignUpButton()
        }
        .background(Color("LightBlue"))
    }
    
    func login() {
        FirebaseService.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let user):
                tD.currentUser = user
                tD.loggedIn = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct Heading: View {
    var body: some View {
        VStack {
            Text("Recess")
                .foregroundColor(Color("TextBlue"))
                .font(.largeTitle)
                .bold()
                .padding(.top)
            Text("It's game time")
                .foregroundColor(Color("TextBlue"))
                .font(.title3)
                .padding(.bottom)
        }
    }
}

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                       text: $email)
        .modifier(FormField())
    }
}

struct PasswordTextField: View {
    @Binding var password: String
    
    var body: some View {
        SuperPassCodeField(placeholder: Text("   Password").foregroundColor(.white),
                           text: $password)
        .modifier(FormField())
    }
}

struct ForgotPasswordLink: View {
    var body: some View {
        NavigationLink(destination: ForgotPasswordView(), label: {
            Text("Forgot Password")
                .foregroundColor(Color("TextBlue"))
                .font(.subheadline)
                .underline()
        })
    }
}

struct ErrorMessageText: View {
    @Binding var errorMessage: String
    
    var body: some View {
        Text(errorMessage)
            .foregroundColor(.orange)
            .bold()
    }
}

struct LoginButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
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
    }
}

struct SignUpButton: View {
    @EnvironmentObject var tD: TestData
    
    var body: some View {
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
}

class FirebaseService {
    static let shared = FirebaseService()

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            Firestore.firestore().collection("Users").whereField("emailAddress", isEqualTo: email).getDocuments() { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                for document in documentSnapshot!.documents {
                    do {
                        let user = try document.data(as: User.self)
                        completion(.success(user))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(TestData())
    }
}
