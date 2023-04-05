//
//  AchievementListItem.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct AchievementListItem: View {
    var achievement: String
    var body: some View {
        VStack {
            Image(achievement)
            Text(achievement)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(Color("TextBlue"))
                .padding(.bottom)
        }
    }
}

struct AchievementListItem_Previews: PreviewProvider {
    static var previews: some View {
        AchievementListItem(achievement: "Name")
    }
}
