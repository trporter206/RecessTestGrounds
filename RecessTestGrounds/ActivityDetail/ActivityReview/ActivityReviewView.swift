//
//  ActivityReviewView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewView: View {
    @Binding var activity: Activity
    @State var winningTeam = 0
    
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
                Text("Winning Team")
                Picker("Select winning team", selection: $winningTeam) {
                    Text("Team 1").tag(0)
                    Text("Team 2").tag(1)
                }
                .pickerStyle(.segmented)
                .padding([.leading, .trailing])
                Text("Players")
                ForEach($activity.players) { $player in
                    ActivityReviewPlayerItem(player: $player)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.orange)
                        .frame(width: 300, height: 60)
                    Text("Submit")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                
            }
            .background(Color("LightBlue"))
        }
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0])).environmentObject(TestData())
    }
}
