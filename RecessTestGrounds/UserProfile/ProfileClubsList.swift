//
//  ProfileClubsList.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ProfileClubsList: View {
    @Binding var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Clubs")
                .modifier(SectionHeader())
            ScrollView(.horizontal) {
                HStack {
                    ForEach($user.clubs) { $club in
                        ClubListItem(club: $club)
                    }
                }.padding()
            }
        }
    }
}

struct ProfileClubsList_Previews: PreviewProvider {
    static var previews: some View {
        ProfileClubsList(user: .constant(usersData[0]))
    }
}
