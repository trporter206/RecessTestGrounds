//
//  ForgotPasswordView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-20.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State var email = ""
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                           text: $email)
            .modifier(FormField())
            SendEmailButton(email: $email, errorMessage: $errorMessage)
            ErrorMessageText(errorMessage: $errorMessage)
        }
        .background(Color("LightBlue"))
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
