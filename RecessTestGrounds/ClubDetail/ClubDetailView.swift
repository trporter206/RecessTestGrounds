//
//  ClubDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-31.
//

import SwiftUI

struct ClubDetailView: View {
    @Binding var club: Club
    
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ClubHeaderView(club: club)
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.orange)
                        .frame(width: 300, height: 60)
                    Text("Join Club")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .padding(.bottom)
                Text("Members")
                    .modifier(SectionHeader())
                LazyVGrid(columns: gridItemLayout) {
                    ForEach($club.members) { $member in
                        ClubMemberListItem(member: $member)
                    }
                }.padding([.leading, .trailing])
               Text("Upcoming Activities")
                    .modifier(SectionHeader())
                ForEach($club.upcomingActivities) { $activity in
                    ActivityListItem(activity: $activity).padding([.leading, .trailing])
                }
            }
        }
        .background(Color("LightBlue"))
    }
}

struct ClubDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClubDetailView(club: .constant(clubsData[0]))
    }
}
