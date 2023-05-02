//
//  MyProfileHeader.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct MyProfileHeader: View {
    var user: User
    var body: some View {
        VStack {
            HStack {
                ProfilePicView(profileString: user.profilePicString, height: 90)
                    .padding([.leading])
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.name)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        NavigationLink(destination: TierView(), label: {
                            Text("Tier \(user.getTier())")
                                .padding(.trailing)
                        })
                        NavigationLink(destination: RatingView(), label: {
                            Image(systemName: "hand.thumbsup")
                            Text(String(user.rating.prefix(2)) + "%")
                                .padding(.trailing)
                        })
                        NavigationLink(destination: PointsView(), label: {
                            Text("\(user.points)")
                                .fontWeight(.heavy)
                                .foregroundColor(.orange)
                        })
                    }
                }
            }
            .padding(.bottom)
        }
        .padding([.top], 50)
        .background(Color("TextBlue"))
        .foregroundColor(.white)
    }
}

struct MyProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileHeader(user: usersData[0])
    }
}
