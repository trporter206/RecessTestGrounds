//
//  ActivityAnnotationDetail-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-06.
//

import Foundation

extension ActivityAnnotationDetailView {
    @MainActor class ViewModel: ObservableObject {
        @Published var userInfo: User = usersData[0]
        @Published var playerlist: [User] = []
        @Published var showingReviewSheet = false
        @Published var showingAlert = false
    }
    
    func onAppear() {
        FirestoreService.shared.getUserInfo(id: activity.wrappedValue.creator) {
            result in
            switch result {
            case .success(let user):
                userInfo = user
            case .failure(let error):
                print("Error decoding creator info: \(error)")
            }
        }
        playerlist = []
        for id in activity.wrappedValue.players {
            FirestoreService.shared.getUserInfo(id: id) {result in
                switch result {
                case .success(let user):
                    playerlist.append(user)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
