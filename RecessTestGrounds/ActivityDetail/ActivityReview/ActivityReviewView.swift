//
//  ActivityReviewView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @State var playerReviews: [Int] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Activity Review")
                    .bold()
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("TextBlue"))
                Text("Duration: ")
                    .padding()
//                if activity.creator.id == tD.currentUser.id {
//                    Text("Winning Team")
//                    Picker("Select winning team", selection: $winningTeam) {
//                        Text("Team 1").tag(0)
//                        Text("Team 2").tag(1)
//                    }
//                    .pickerStyle(.segmented)
//                    .padding([.leading, .trailing])
//                }
                Text("Players")
                ForEach($activity.players.indices) { index in
                    ActivityReviewPlayerItem(activity: $activity,
                                             playerReviews: $playerReviews,
                                             playerIndex: index)
                }
                NavigationLink(destination: DashboardView(), label: {
                    Button(action: {
                        for (index, review) in playerReviews.enumerated() {
                            var user = activity.getPlayerInfo(id: activity.players[index])
                            if review == 1 {
                                user.updateRating(1)
                            } else if review == 0 {
                                user.updateRating(0)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                        tD.activities.removeAll(where: {$0.id == activity.id})
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.orange)
                                .frame(width: 300, height: 60)
                            Text("Submit")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                    })
                })
            }
            .background(Color("LightBlue"))
            .onAppear {
                playerReviews = Array(repeating: 2, count: activity.players.count)
            }
        }
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0])).environmentObject(TestData())
    }
}
