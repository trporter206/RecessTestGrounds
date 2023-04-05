//
//  ActivityDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-31.
//

import SwiftUI
import CoreLocation

struct ActivityDetailView: View {
    @Binding var activity: Activity
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.coordinates[0], longitude: activity.coordinates[1]))
                    .frame(height: 260)
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
                if activity.currentlyActive {
                    Text("Currently Active").padding()
                } else {
                    Text("This activity has not started yet").padding()
                }
                Text("Players (\(activity.playerCount))")
                    .foregroundColor(Color("TextBlue"))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($activity.players) { player in
                            ProfilePicView(user: player, height: 60)
                        }
                    }
                    .padding(.leading)
                }
                Text("Date: \(activity.getDate())")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.top)
                ActivityActionButtonView(activity: $activity)
            }
            
        }
        .background(Color("LightBlue"))
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: .constant(activitiesData[0]))
            .environmentObject(TestData())
    }
}
