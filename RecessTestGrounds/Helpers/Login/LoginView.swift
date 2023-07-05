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
    @State private var isLoggingIn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Heading()
                EmailTextField(email: $vM.email)
                PasswordTextField(password: $vM.password)
                ForgotPasswordLink()
                Spacer()
                NavigationLink(destination: ExploreMapView(exploreMode: true).environmentObject(lM), label: {
                    Text("Just Explore")
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(Color("TextBlue")))
                })
                Spacer()
                ErrorMessageText(errorMessage: $vM.errorMessage)
                Spacer()
                
                if isLoggingIn {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                } else {
                    LoginButton(action: login)
                    SignUpButton().environmentObject(tD)
                }
            }
            .background(Color("LightBlue"))
            .onAppear {
                lM.checkIfLocationServicesEnabled()
            }
        }
    }
    
    func login() {
        isLoggingIn = true
        FirestoreService.shared.login(email: vM.email.lowercased(), password: vM.password) { result in
            isLoggingIn = false
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
