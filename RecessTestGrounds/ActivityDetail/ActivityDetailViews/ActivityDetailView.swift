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
    @State var showingReviewSheet = false
    @State var showingAlert = false
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
                if activity.description != "" {
                    Text(activity.description)
                        .foregroundColor(Color("TextBlue"))
                        .fontWeight(.light)
                        .padding([.leading, .bottom, .trailing])
                }
                Divider().padding([.leading, .trailing])
                if activity.currentlyActive {
                    Text("Currently Active")
                        .foregroundColor(Color("TextBlue"))
                        .bold()
                        .padding()
                } else {
                    Text("This activity has not started yet").padding()
                }
                Text("Players (\($playerlist.count))")
                    .foregroundColor(Color("TextBlue"))
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($playerlist) { $player in
                            ProfilePicView(profileString: $player.wrappedValue.profilePicString, height: 60)
                        }
                    }
                    .padding(.leading)
                }
                Text("Date: \(activity.date.formatted())")
                    .foregroundColor(Color("TextBlue"))
                    .padding(.top)
                ActivityActionButtonView(activity: $activity, playerList: $playerlist, showingReview: $showingReviewSheet)
                    .environmentObject(tD)
                if tD.currentUser.id == activity.creator {
                    Button(action: {
                        Firestore.firestore().collection("Activities").document(activity.id).delete() { error in
                            if let error = error {
                                print("Error deleting document: \(error)")
                            }
                        }
                        if let indexToRemove = tD.activities.firstIndex(where: {$0.id == activity.id}) {
                            tD.activities.remove(at: indexToRemove)
                        }
                        showingAlert = true
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Delete").foregroundColor(.red)
                    })
                    .alert("Activity Deleted", isPresented: $showingAlert) {
                        Button("OK", role: .cancel){}
                    }
                
                }
            }
            .onAppear {
                getCreatorInfo()
                getPlayerList()
            }
            
        }
        .background(Color("LightBlue"))
        .sheet(isPresented: $showingReviewSheet, content: {
            ActivityReviewView(activity: $activity, playerList: $playerlist, presentationMode: _presentationMode)
        })
    }
}

extension ActivityDetailView {
    
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

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: .constant(activitiesData[0]))
            .environmentObject(TestData())
    }
}
