//
//  ActivityAnnotationDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-02.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

struct ActivityAnnotationDetailView: View {
    var activity: Activity
    var tD: TestData
    @State var userInfo: User = usersData[0]
    @State var playerlist: [User] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ActivityMapView(coordinate: CLLocationCoordinate2D( latitude: activity.coordinates[0], longitude: activity.coordinates[1]))
                    .frame(height: 260)
                HStack {
                    NavigationLink(destination: PlayerProfile(tD: tD, player: $userInfo), label: {
                        ProfilePicView(profileString: userInfo.profilePicString, height: 90)
                    })
                    VStack {
                        Text(activity.sport)
                            .foregroundColor(Color("TextBlue"))
                            .font(.largeTitle)
                        Text("Hosted by \(userInfo.name)")
                            .font(.subheadline)
                            .foregroundColor(Color("TextBlue"))
                    }
                }
                ActivityDescription(activity: activity)
                Divider().padding([.leading, .trailing])
                if activity.currentlyActive {
                    Text("Currently Active")
                        .foregroundColor(Color("TextBlue"))
                        .bold()
                        .padding()
                } else {
                    Text("This activity has not started yet").padding()
                }
                ActivityPlayerList(playerList: $playerlist)
                ActivityDateView(activity: activity)
                Spacer()
                Text("View on Dashboard or Activities List to join")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.orange)
                    .padding()
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            getCreatorInfo()
            getPlayerList()
        }
    }
}

extension ActivityAnnotationDetailView {
    func getCreatorInfo() {
        Firestore.firestore().collection("Users").document(activity.creator).getDocument() { documentSnapshot, error in
            if let error = error {
                print("Error getting creator info: \(error)")
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    userInfo = user
                } catch {
                    print("Error decoding creator info: \(error)")
                }
            }
        }
    }
    
    func getPlayerList() {
        playerlist = []
        for id in activity.players {
            Firestore.firestore().collection("Users").document(id).getDocument() { documentSnapshot, error in
                if let error = error {
                    print("Error getting player list info: \(error)")
                } else {
                    do {
                        let user = try documentSnapshot!.data(as: User.self)
                        playerlist.append(user)
                    } catch {
                        print("Error decoding playerlist info: \(error)")
                    }
                }
            }
        }
    }
}

struct ActivityAnnotationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAnnotationDetailView(activity: activitiesData[0], tD: TestData())
    }
}
