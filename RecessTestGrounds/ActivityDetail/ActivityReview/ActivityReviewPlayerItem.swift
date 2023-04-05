//
//  ActivityReviewPlayerItem.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewPlayerItem: View {
    @Binding var player: User
    
    var body: some View {
        HStack {
            ProfilePicView(user: $player, height: 60)
            Text(player.name)
            Spacer()
            Image(systemName: "hand.thumbsup.fill")
                .foregroundColor(Color("TextBlue"))
            Image(systemName: "hand.thumbsdown.fill")
                .foregroundColor(Color("TextBlue"))
            Image(systemName: "xmark")
                .foregroundColor(Color("TextBlue"))
                .padding([.trailing, .vertical])
        }
        .frame(maxWidth: 350)
        .background(RoundedRectangle(cornerRadius: 50)
            .foregroundColor(.white)
            .shadow(radius: 1))
    }
}

struct ActivityReviewPlayerItem_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewPlayerItem(player: .constant(TestData().currentUser))
    }
}
