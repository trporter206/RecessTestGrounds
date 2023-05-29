//
//  Login-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-28.
//

import Foundation
import FirebaseAuth
import SwiftUI

extension LoginView {
    @MainActor class ViewModel: ObservableObject {
        @EnvironmentObject var tD: TestData
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage = ""
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

struct SendEmailButton: View {
    @Binding var email: String
    @Binding var errorMessage: String
    
    var body: some View {
        Button(action: {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil {
                    print(error!)
                    errorMessage = error!.localizedDescription
                } else {
                    errorMessage = "Email Sent"
                }
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.orange)
                    .frame(width: 300, height: 60)
                Text("Send Email")
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
        })
    }
}
