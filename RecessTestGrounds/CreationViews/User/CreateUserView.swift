//
//  CreateUserView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-11.
//

import SwiftUI
import FirebaseAuth

struct CreateUserView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                CreateProfileHeader()
                CreateUserFields(userData: $viewModel.userData,
                                 password: $viewModel.password,
                                 confirmedPassword: $viewModel.confirmedPassword,
                                 chosenAvatar: $viewModel.chosenAvatar).environmentObject(tD).padding()
                Spacer()
                ErrorMessageText(errorMessage: $viewModel.errorMessage)
                Spacer()
                if tD.loggedIn {
                    UpdateProfileButton(user: $viewModel.userData, chosenAvatar: $viewModel.chosenAvatar)
                } else {
                    SignUpProfileButton(userData: $viewModel.userData,
                                        errorMessage: $viewModel.errorMessage,
                                        chosenAvatar: $viewModel.chosenAvatar,
                                        password: $viewModel.password,
                                        confirmedPassword: $viewModel.confirmedPassword,
                                        showingAlert: $viewModel.showingAlert)
                }
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            if tD.loggedIn {
                viewModel.userData = tD.currentUser.data
                viewModel.chosenAvatar = tD.currentUser.profilePicString
            }
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView()
    }
}
