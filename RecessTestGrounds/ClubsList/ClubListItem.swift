//
//  FeaturedClub.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct ClubListItem: View {
    @Binding var club: Club
    
    var body: some View {
        NavigationLink(destination: ClubDetailView(club: $club), label: {
            HStack {
                ProfilePicView(profileString: club.creator.profilePicString, height: 90)
                VStack(alignment: .leading) {
                    Text(club.name)
                        .font(.title3)
                        .lineLimit(1)
                        .foregroundColor(Color("TextBlue"))
                        .bold()
                    Text(club.sport)
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextBlue"))
                    HStack {
                        Text("\(club.members.count)").fontWeight(.light)
                        Image(systemName: "person.3.fill").padding(.trailing)
                        Text("\(club.numActivities)").fontWeight(.light)
                        Image(systemName: "calendar").padding(.trailing)
                        Image(systemName: "dollarsign")
                    }
                    .foregroundColor(Color("TextBlue"))
                }
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 50)
                .foregroundColor(.white)
                .shadow(radius: 1))
            .frame(minWidth: 350)
        })
    }
}

struct FeaturedClub_Previews: PreviewProvider {
    static var previews: some View {
        ClubListItem(club: .constant(clubsData[0]))
    }
}
