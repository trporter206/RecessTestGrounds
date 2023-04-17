//
//  ActivityDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-31.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityDetailView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @State var userInfo: User = usersData[0]
    @State var playerlist: [User] = []
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.coordinates[0], longitude: activity.coordinates[1]))
                    .frame(height: 260)
                HStack {
                    ProfilePicView(user: activity.creator, height: 90)
                    VStack {
                        Text(activity.sport)
                            .foregroundColor(Color("TextBlue"))
                            .font(.largeTitle)
                        Text("Hosted by \(userInfo.name)")
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
                Text("Players (\($playerlist.count))")
                    .foregroundColor(Color("TextBlue"))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($playerlist) { $player in
                            ProfilePicView(user: $player.wrappedValue.id, height: 60)
                        }
                    }
                    .padding(.leading)
                }
                Text("Date: \(activity.getDate())")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.top)
                ActivityActionButtonView(activity: $activity, playerList: $playerlist)
                    .environmentObject(tD)
            }
            .onAppear {
                getCreatorInfo()
                getPlayerList()
            }
            
        }
        .background(Color("LightBlue"))
    }
}

extension ActivityDetailView {
    
    func getCreatorInfo() {
        Firestore.firestore().collection("Users").document(activity.creator).getDocument() { documentSnapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    userInfo = user
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getPlayerList() {
        for id in activity.players {
            Firestore.firestore().collection("Users").document(id).getDocument() { documentSnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    do {
                        let user = try documentSnapshot!.data(as: User.self)
                        playerlist.append(user)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: .constant(activitiesData[0]))
            .environmentObject(TestData())
    }
}
