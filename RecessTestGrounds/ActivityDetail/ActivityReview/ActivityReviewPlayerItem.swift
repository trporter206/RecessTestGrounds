//
//  ActivityReviewPlayerItem.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

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

struct ActivityReviewPlayerItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewPlayerItem(playerList: .constant([]), playerReviews: .constant([]), playerIndex: 0)
    }
}
