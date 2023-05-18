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
    @EnvironmentObject var lM: LocationManager
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
                PlayerProfileLink(activity: $activity, userInfo: $userInfo)
                ActivityDescription(activity: activity)
                Divider().padding([.leading, .trailing])
                ActivityStatus(activity: $activity)
                ActivityPlayerList(playerList: $playerlist)
                ActivityDateView(activity: activity)
                ActivityActionButtonView(activity: $activity, playerList: $playerlist, showingReview: $showingReviewSheet)
                    .environmentObject(tD)
                    .environmentObject(lM)
                ActivityDeleteButton(activity: $activity, showingAlert: $showingAlert)
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

struct PlayerProfileLink: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var userInfo: User
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayerProfile(tD: tD, player: $userInfo), label: {
                ProfilePicView(profileString: userInfo.profilePicString, height: 90)
            })
            VStack(alignment: .leading) {
                if activity.title != "" {
                    Text(activity.title).bold().font(.title)
                    Text(activity.sport).fontWeight(.light)
                } else {
                    Text(activity.sport).bold().font(.title)
                }
                Text("Hosted by \(userInfo.name)")
                    .font(.subheadline)
            }
            .foregroundColor(Color("TextBlue"))
        }
        .padding(.bottom)
    }
}

struct ActivityDescription: View {
    let activity: Activity
    
    var body: some View {
        if activity.description != "" {
            Text(activity.description)
                .foregroundColor(Color("TextBlue"))
                .fontWeight(.light)
                .padding([.leading, .bottom, .trailing])
        }
    }
}

struct ActivityStatus: View {
    @Binding var activity: Activity
    
    var body: some View {
        if activity.currentlyActive {
            Text("Currently Active")
                .foregroundColor(Color("TextBlue"))
                .bold()
                .padding()
        } else {
            Text("This activity has not started yet").padding()
        }
    }
}

struct ActivityPlayerList: View {
    @Binding var playerList: [User]
    
    var body: some View {
        Text("Players (\($playerList.count))")
            .foregroundColor(Color("TextBlue"))
        ScrollView(.horizontal) {
            HStack {
                ForEach($playerList) { $player in
                    ProfilePicView(profileString: $player.wrappedValue.profilePicString, height: 60)
                }
            }
            .padding(.leading)
        }
    }
}

struct ActivityDateView: View {
    let activity: Activity
    
    var body: some View {
        Text("Date: \(activity.date.formatted())")
            .foregroundColor(Color("TextBlue"))
            .padding(.top)
    }
}

struct ActivityDeleteButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var showingAlert: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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

//struct ActivityDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityDetailView(activity: .constant(activitiesData[0]))
//            .environmentObject(TestData())
//    }
//}
