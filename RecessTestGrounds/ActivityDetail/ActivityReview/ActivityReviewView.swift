//
//  ActivityReviewView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var playerList: [User]
    @State var playerReviews: [Int] = []
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Activity Review")
                .bold()
                .font(.system(size: 36))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color("TextBlue"))
            ActivityReviewPlayerList(playerList: $playerList, playerReviews: $playerReviews)
            Spacer()
            ActivityReviewSubmitButton(action: closeOutActivity)
        }
        .background(Color("LightBlue"))
        .onAppear {
            playerReviews = Array(repeating: 2, count: playerList.count-1)
        }
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

extension ActivityReviewView {
    func addReviewsForParticipants() {
        for (index, review) in playerReviews.enumerated() {
            let userInstance = playerList[index]
            let rating = playerList[index].updateRating(review)
            FirestoreService.shared.updatePoints(user: userInstance, points: 25)
            FirestoreService.shared.updateRating(user: userInstance, rating: rating)
            FirestoreService.shared.updateReviewCounts(user: userInstance, review: review)
        }
    }
    
    func closeOutActivity() {
        let points = 50 + ((playerList.count - 1) * 5)
        let tierBeforeNewPoints = tD.currentUser.tier
        tD.currentUser.addPoints(points)
        FirestoreService.shared.updatePoints(user: tD.currentUser, points: points)
        let tierAfterNewPoints = tD.currentUser.tier
        if tierBeforeNewPoints < tierAfterNewPoints {
            FirestoreService.shared.updateTier(user: tD.currentUser, tier: tierAfterNewPoints)
        }
        addReviewsForParticipants()
        
        dismiss()
        presentationMode.wrappedValue.dismiss()
        FirestoreService.shared.deleteActivity(activity: activity)
        tD.activities.removeAll(where: {$0.id == activity.id})
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0]), playerList: .constant([]))
            .environmentObject(TestData())
    }
}
