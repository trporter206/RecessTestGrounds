//
//  ActivityDetailHeader.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityDetailHeader: View {
    @Binding var activity: Activity
    var body: some View {
        VStack {
            HStack {
                ProfilePicView(user: $activity.creator, height: 90)
                VStack {
                    Text(activity.sport)
                        .foregroundColor(Color("TextBlue"))
                        .font(.largeTitle)
                    Text("Hosted by \(activity.creator.name)")
                        .font(.subheadline)
                        .foregroundColor(Color("TextBlue"))
                }
            }
            if activity.description != "" {
                Text(activity.description)
                    .foregroundColor(Color("TextBlue"))
                    .fontWeight(.light)
                    .padding([.leading, .bottom, .trailing])
            }
            Divider().padding([.leading, .trailing])
        }
    }
}

struct ActivityDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailHeader(activity: .constant(activitiesData[0]))
    }
}
