//
//  NextActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI

struct NextActivityView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: $activity).environmentObject(lM)
            .environmentObject(tD), label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .frame(height: 350)
                    .padding()
                    .shadow(radius: 1)
                VStack (alignment: .leading) {
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            ProfilePicView(user: $activity.creator, height: 90)
                            Text("\(activity.creator.points)")
                                .foregroundColor(.orange)
                                .fontWeight(.heavy)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1))
                        }
                        .padding([.leading, .trailing])
                        VStack (alignment: .leading) {
                            Text(activity.getSport()).bold().font(.title)
                            Text("Hosted by \(activity.creator.getName())")
                            Divider()
                            HStack {
                                Spacer()
                                Text("Mar 7, 2:30pm").fontWeight(.light)
                            }
                        }.padding(.trailing)
                    }
                    Text("\(activity.getPlayerCount())/\(activity.getMaxPlayers()) Players").bold().padding([.leading, .top])
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($activity.players) { $player in
                                ProfilePicView(user: $player, height: 60)
                            }
                        }.padding([.leading, .trailing])
                    }
                    Text(activity.getDescription()).padding()
                }.padding()
            }
            .foregroundColor(Color("TextBlue"))
        })
    }
}

struct NextActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NextActivityView(activity: .constant(activitiesData[0]))
    }
}
