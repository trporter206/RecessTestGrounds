//
//  LoginView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-12.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @StateObject private var vM = ViewModel()
    
    var body: some View {
        VStack {
            Heading()
            EmailTextField(email: $vM.email)
            PasswordTextField(password: $vM.password)
            ForgotPasswordLink()
            Spacer()
            ErrorMessageText(errorMessage: $vM.errorMessage)
            Spacer()
            LoginButton(action: login)
            SignUpButton()
        }
        .background(Color("LightBlue"))
    }
    
    func login() {
        FirestoreService.shared.login(email: vM.email.lowercased(), password: vM.password) { result in
            switch result {
            case .success(let user):
                tD.currentUser = user
                tD.loggedIn = true
                tD.getActivities()
            case .failure(let error):
                vM.errorMessage = error.localizedDescription
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(TestData())
    }
}
