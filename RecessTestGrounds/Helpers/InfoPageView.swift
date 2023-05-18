//
//  InfoPageView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-05.
//

import SwiftUI

struct InfoPageView: View {
    var body: some View {
//                Text("Features to come")
//                    .modifier(SectionHeader())
//                Text("Clubs - Create communities for like minded sports enthusiasts. ")
//                Text("Friends - Request to connect with your favorite players to quickly find them again for future activities")
//            }
//            .padding()
//        }
//        .background(Color("LightBlue"))
        ScrollView(.vertical) {
            Text("Welcome to Recess")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
            Text("Welcome to version 1.0 of Recess, built solely by Torri Porter with the goal of providing a platform for athletes and casual players to find games and new people to play with.")
                .foregroundColor(Color("TextBlue"))
                .padding()
                .multilineTextAlignment(.center)
            Divider().padding([.leading, .trailing,.bottom])
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Activities")
                        .modifier(TierTitle())
                        .padding(.vertical)
                    Text("Activities are the primary feature of Recess. You can schedule an activity for later or start one immediately. For now, anyone can join an activity going on in their area")
                        .modifier(TierText())
                }.padding(.bottom)
                VStack(alignment: .leading) {
                    Text("Points and Tiers")
                        .modifier(TierTitle())
                        .padding(.vertical)
                    Text("Earn points by hosting and joining activities. Points are an easy way to see how much a user engages with their community. Enough points will increase your tier. Tiers don't have much function now, but they'll have a big role in future versions")
                        .modifier(TierText())
                }.padding(.bottom)
                VStack(alignment: .leading) {
                    Text("Features to come")
                        .modifier(TierTitle())
                        .padding(.vertical)
                    Text("Clubs - Create communities for like minded sports enthusiasts. ")
                        .modifier(TierText())
                    Text("Followers - Follow friends to be notified when they start or join an activity. ")
                        .modifier(TierText())
                }.padding(.bottom)
                VStack(alignment: .leading) {
                    Text("Feedback")
                        .modifier(TierTitle())
                        .padding(.vertical)
                    Text("Any feedback is welcomed, I'd love your input. Send any ideas, questions, or any other queries to tr.porter206@gmail.com")
                        .modifier(TierText())
                }.padding(.bottom)
            }.padding(.horizontal)
        }
        .background(Color("LightBlue"))
    }
}

struct InfoPageView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPageView()
    }
}
