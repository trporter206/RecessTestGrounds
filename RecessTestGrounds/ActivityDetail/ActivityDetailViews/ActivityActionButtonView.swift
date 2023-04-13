//
//  ActivityActionButtonView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityActionButtonView: View {
    @EnvironmentObject var tD: TestData
//    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    
    var body: some View {
        VStack {
            if tD.currentUser.id == activity.creator {
                if activity.currentlyActive {
                    NavigationLink(destination: ActivityReviewView(activity: $activity), label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.orange)
                                .frame(width: 300, height: 60)
                            Text("End Activity")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                    })
                } else {
                    Button(action: {
                        activity.currentlyActive = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.orange)
                                .frame(width: 300, height: 60)
                            Text("Start Activity")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                    })
                }
            } else {
                Button(action: {
                    activity.addPlayer(tD.currentUser)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.orange)
                            .frame(width: 300, height: 60)
                        Text("Join Activity")
                            .foregroundColor(.white)
                            .bold()
                    }
                })
                .padding()
                Text("Join to see activity messages")
                    .foregroundColor(Color("TextBlue"))
                    .fontWeight(.light)
            }
        }
    }
}

struct ActivityActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityActionButtonView(activity: .constant(TestData().activities[0])).environmentObject(TestData())
    }
}
