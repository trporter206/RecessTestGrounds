//
//  ActivityReview-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-28.
//

import Foundation
import SwiftUI

extension ActivityReviewView {
    @MainActor class ViewModel: ObservableObject {
        @Published var playerReviews: [Int] = []
    }
    
    func addReviewsForParticipants(_ vM: ViewModel) {
        for (index, review) in vM.playerReviews.enumerated() {
            let userInstance = playerList[index]
            let rating = playerList[index].updateRating(review)
            FirestoreService.shared.updatePoints(user: userInstance, points: 25)
            FirestoreService.shared.updateRating(user: userInstance, rating: rating)
            FirestoreService.shared.updateReviewCounts(user: userInstance, review: review)
        }
    }
    
    func closeOutActivity(_ vM: ViewModel) {
        let points = 50 + ((playerList.count - 1) * 5)
        let tierBeforeNewPoints = tD.currentUser.tier
        tD.currentUser.addPoints(points)
        FirestoreService.shared.updatePoints(user: tD.currentUser, points: points)
        let tierAfterNewPoints = tD.currentUser.tier
        if tierBeforeNewPoints < tierAfterNewPoints {
            FirestoreService.shared.updateTier(user: tD.currentUser, tier: tierAfterNewPoints)
        }
        addReviewsForParticipants(vM)
        
        dismiss()
        presentationMode.wrappedValue.dismiss()
        FirestoreService.shared.deleteActivity(activity: activity)
        tD.activities.removeAll(where: {$0.id == activity.id})
    }
}

struct ActivityReviewPlayerItem: View {
    @Binding var playerList: [User]
    @Binding var playerReviews: [Int]
    @State var ratingChoice = "none"
    var playerIndex: Int
    
    var body: some View {
        HStack {
            ProfilePicView(profileString: playerList[playerIndex].profilePicString, height: 60)
            Text(playerList[playerIndex].name).foregroundColor(Color("TextBlue"))
            Spacer()
            ReviewButton(playerReviews: $playerReviews,
                         ratingChoice: $ratingChoice,
                         playerIndex: playerIndex,
                         color: .green,
                         ratingNum: 1,
                         ratingString: "positive",
                         imageString: "hand.thumbsup.fill")
            ReviewButton(playerReviews: $playerReviews,
                         ratingChoice: $ratingChoice,
                         playerIndex: playerIndex,
                         color: .red,
                         ratingNum: 0,
                         ratingString: "negative",
                         imageString: "hand.thumbsdown.fill")
        }
        .frame(maxWidth: 350)
        .background(RoundedRectangle(cornerRadius: 50)
            .foregroundColor(.white)
            .shadow(radius: 1))
    }
}

struct ReviewButton: View {
    @Binding var playerReviews: [Int]
    @Binding var ratingChoice: String
    var playerIndex: Int
    var color: Color
    var ratingNum: Int
    var ratingString: String
    var imageString: String
    
    var body: some View {
        Button(action: {
            playerReviews[playerIndex] = ratingNum
            ratingChoice = ratingString
        }, label: {
            Image(systemName: imageString)
                .foregroundColor({ratingChoice == ratingString ? color : Color("TextBlue")}())
                .padding(.trailing)
        })
    }
}

struct ActivityReviewPlayerList: View {
    @EnvironmentObject var tD: TestData
    @Binding var playerList: [User]
    @Binding var playerReviews: [Int]
    
    var body: some View {
        Text("Players")
        ScrollView(.vertical) {
            VStack {
                ForEach($playerList.filter({$0.id != tD.currentUser.id}).indices) { index in
                    ActivityReviewPlayerItem(playerList: $playerList,
                                             playerReviews: $playerReviews,
                                             playerIndex: index)
                }
            }
        }
    }
}

struct ActivityReviewSubmitButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.orange)
                    .frame(width: 300, height: 60)
                Text("Submit")
                    .foregroundColor(.white)
                    .bold()
            }
            .padding()
        })
    }
}
