//
//  FriendRequestListItemView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-06.
//

import SwiftUI

struct FriendRequestListItemView: View {
    @Binding var request: FriendRequest
    @Binding var user: User
    
    var body: some View {
        VStack {
            ProfilePicView(user: request.sender.id, height: 60)
            HStack {
                Button(action: {
                    user.acceptRequest(request: request)
                }, label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .bold()
                })
                .padding(.trailing)
                Button(action: {
                    user.rejectRequest(request: request)
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .bold()
                })
            }
            .padding([.top], 2)
        }
    }
}

struct FriendRequestListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestListItemView(request: .constant(FriendRequest(sender: usersData[0], receiver: usersData[1])), user: .constant(usersData[1]))
    }
}
