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
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    ProfilePicView(profileString: user.profilePicString, height: 100)
                    NavigationLink(destination: PointsView(), label: {
                        Text("\(user.points)")
                            .foregroundColor(.orange)
                            .fontWeight(.heavy)
                            .padding(4)
                            .background(RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 1))
                    })
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.largeTitle)
                        .bold()
                    HStack {
                        NavigationLink(destination: TierView(), label: {
                            HStack {
                                Text("Tier")
                                    .bold()
                                Text("\(user.getTier())")
                                    .foregroundColor(.orange)
                                    .bold()
                            }
                        })
                        NavigationLink(destination: RatingView(), label: {
                            Image(systemName: "hand.thumbsup").bold()
                            Text(String(user.rating.prefix(2)) + "%")
                                .foregroundColor(.orange)
                                .bold()
                        })
                    }
                }
                Spacer()
            }
            .padding()
        }
        .background(Color("TextBlue"))
        .foregroundColor(.white)
    }
}

struct MyProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileHeader(user: usersData[0])
    }
}
