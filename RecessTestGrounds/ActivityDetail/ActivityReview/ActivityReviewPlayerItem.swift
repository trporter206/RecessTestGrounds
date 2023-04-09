//
//  ActivityReviewPlayerItem.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewPlayerItem: View {
    @Binding var activity: Activity
    @Binding var playerReviews: [Int]
    @State var ratingChoice = "none"
    var playerIndex: Int
    
    var body: some View {
        HStack {
            ProfilePicView(user: $activity.players[playerIndex], height: 60)
            Text(activity.players[playerIndex].name)
            Spacer()
            Button(action: {
                playerReviews[playerIndex] = 1
                ratingChoice = "positive"
            }, label: {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor({ratingChoice == "positive" ? .green : Color("TextBlue")}())
                    .padding(.trailing)
            })
            Button(action: {
                playerReviews[playerIndex] = 0
                ratingChoice = "negative"
            }, label: {
                Image(systemName: "hand.thumbsdown.fill")
                    .foregroundColor({ratingChoice == "negative" ? .red : Color("TextBlue")}())
                    .padding(.trailing)
            })
        }
        .frame(maxWidth: 350)
        .background(RoundedRectangle(cornerRadius: 50)
            .foregroundColor(.white)
            .shadow(radius: 1))
    }
}

struct ActivityReviewPlayerItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewPlayerItem(activity: .constant(TestData().activities[0]), playerReviews: .constant([]), playerIndex: 0)
    }
}
