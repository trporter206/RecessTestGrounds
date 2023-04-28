//
//  RatingView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-18.
//

import SwiftUI

struct RatingView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Player Rating")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
            Text("Your rating is the number of positive reviews you've recieved divided by your total number of recieved views. Show up to activities with good sportsmanship to recieve a better rating!")
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
                .multilineTextAlignment(.center)
            Divider().padding([.leading, .trailing,.bottom])
            Spacer()
        }
        .background(Color("LightBlue"))
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
