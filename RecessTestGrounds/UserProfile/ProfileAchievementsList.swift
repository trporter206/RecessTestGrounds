//
//  ProfileAchievementsList.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ProfileAchievementsList: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: AchievementView(), label: {
                Text("Your Achievements")
                    .modifier(SectionHeader())
            })
            ScrollView(.horizontal){
                HStack {
                    ForEach(myAchievements, id:\.self) { achievement in
                        Image(achievement)
                    }
                }
            }
        }
    }
}

struct ProfileAchievementsList_Previews: PreviewProvider {
    static var previews: some View {
        ProfileAchievementsList()
    }
}
