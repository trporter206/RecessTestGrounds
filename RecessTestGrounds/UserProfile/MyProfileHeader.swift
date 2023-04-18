//
//  MyProfileHeader.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct MyProfileHeader: View {
    @Binding var user: User
    var body: some View {
        VStack {
            HStack {
                ProfilePicView(user: user.id, height: 90)
                    .padding([.leading])
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.name)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        Image(systemName: "gearshape")
                            .padding(.trailing)
                            .font(.system(size: 25))
                    }
                    NavigationLink(destination: TierView(), label: {
                        HStack {
                            Text("Tier \(user.getTier())")
                                .padding(.trailing)
                            Image(systemName: "hand.thumbsup")
                            Text(String(user.rating.prefix(2)) + "%")
                                .padding(.trailing)
                            Text("\(user.points)")
                                .fontWeight(.heavy)
                                .foregroundColor(.orange)
                        }
                    })
                    Rectangle()
                        .frame(height: 10)
                        .padding([.trailing])
                }
            }
            .padding(.bottom)
        }
        .padding([.top], 60)
        .background(Color("TextBlue"))
        .foregroundColor(.white)
    }
}

struct MyProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileHeader(user: .constant(usersData[0]))
    }
}
