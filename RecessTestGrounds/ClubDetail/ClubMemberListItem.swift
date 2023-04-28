//
//  ClubMemberListItem.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ClubMemberListItem: View {
    @Binding var member: User
    
    var body: some View {
        VStack {
            ProfilePicView(profileString: member.profilePicString, height: 90)
            Text(member.name.split(separator: " ")[0])
        }
    }
}

struct ClubMemberListItem_Previews: PreviewProvider {
    static var previews: some View {
        ClubMemberListItem(member: .constant(usersData[0]))
    }
}
