//
//  ClubHeaderView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ClubHeaderView: View {
    var club: Club
    
    var body: some View {
        VStack {
            Text(club.name)
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .multilineTextAlignment(.center)
            Text(club.sport)
                .foregroundColor(Color("TextBlue"))
            HStack {
                Text("\(club.members.count)")
                Image(systemName: "person.3.fill")
                    .padding(.trailing)
                Text("\(club.numActivities)")
                Image(systemName: "calendar")
            }
            .foregroundColor(Color("TextBlue"))
            .padding([.all],2)
            Text(club.description)
                .foregroundColor(Color("TextBlue"))
                .fontWeight(.light)
                .padding([.leading, .trailing, .bottom])
            Divider().padding([.leading, .trailing, .bottom])
        }
    }
}

struct ClubHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ClubHeaderView(club: clubsData[0])
    }
}
