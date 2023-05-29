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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
