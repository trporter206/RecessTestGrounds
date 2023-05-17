//
//  AuthenticationService.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-16.
//

//import Foundation
//import FirebaseAuth
//import FirebaseFirestore
//
//class AuthenticationService: ObservableObject {
//    @Published var currentUser: User?
//    @Published var isLoggedIn = false
//    @Published var errorMessage = ""
//
//    func login(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.errorMessage = "Error reaching data: \(error.localizedDescription)"
//                return
//            }
//            self.fetchUserInfo(email: email)
//        }
//    }
//
//    private func fetchUserInfo(email: String) {
//        Firestore.firestore().collection("Users").whereField("emailAddress", isEqualTo: email).getDocuments() { documentSnapshot, error in
//            if let error = error {
//                self.errorMessage = "Error getting user info: \(error.localizedDescription)"
//                return
//            }
//            do {
//                for document in documentSnapshot!.documents {
//                    self.currentUser = try document.data(as: User.self)
//                    print("Current user is \(self.currentUser?.name ?? "")")
//                }
//                self.isLoggedIn = true
//            } catch {
//                self.errorMessage = "Error decoding info: \(error.localizedDescription)"
//            }
//        }
//    }
//}

