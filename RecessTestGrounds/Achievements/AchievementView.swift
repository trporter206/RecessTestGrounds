//
//  AchievementView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-01.
//

import SwiftUI

struct AchievementView: View {
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            Text("Achievements")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
            Text("Earn achievements by engaging with your community. Achievements help improve your leaderboard ranking and unlock application skins.")
                .foregroundColor(Color("TextBlue"))
                .padding()
                .multilineTextAlignment(.center)
            Divider().padding([.leading, .trailing,.bottom])
            LazyVGrid(columns: gridItemLayout) {
                ForEach(allAchievements, id:\.self) { achievement in
                    AchievementListItem(achievement: achievement)
                }
            }
        }
        .background(Color("LightBlue"))
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}
