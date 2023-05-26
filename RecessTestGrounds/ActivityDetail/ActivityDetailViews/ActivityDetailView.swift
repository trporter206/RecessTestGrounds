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
                PlayerProfileLink(activity: activity,
                                  userInfo: $userInfo)
                ActivityDescription(activity: activity)
                Divider().padding([.leading, .trailing])
                ActivityStatus(activity: $activity)
                ActivityPlayerList(playerList: $playerlist)
                ActivityDateView(activity: activity)
                ActivityActionButtonView(activity: $activity,
                                         playerList: $playerlist,
                                         showingReview: $showingReviewSheet).environmentObject(tD).environmentObject(lM)
                HStack {
                    EditActivityButton(activity: $activity).environmentObject(tD).environmentObject(lM)
                    ActivityDeleteButton(activity: $activity,
                                         showingAlert: $showingAlert)
                }
            }
            .onAppear {
                FirestoreService.shared.getUserInfo(id: activity.creator) {
                    result in
                    switch result {
                    case .success(let user):
                        userInfo = user
                    case .failure(let error):
                        print("Error decoding creator info: \(error)")
                    }
                }
                playerlist = []
                for id in activity.players {
                    FirestoreService.shared.getUserInfo(id: id) {result in
                        switch result {
                        case .success(let user):
                            playerlist.append(user)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
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
    var activity: Activity
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

struct EditActivityButton: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    
    @State var activityData = Activity.Data()
    
    var body: some View {
        NavigationLink(destination: EditActivityView(activityData: $activityData, id: activity.id)
            .environmentObject(tD)
            .environmentObject(lM),
                       label: {
            Text("Edit Activity")
        })
        .onAppear {
            activityData = activity.data
        }
    }
}

struct ActivityDeleteButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var showingAlert: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if tD.currentUser.id == activity.creator {
            Button(action: { showingAlert.toggle() },
                   label: {
                Text("Delete").foregroundColor(.red)
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Delete this activity?"),
                      primaryButton: .default(
                        Text("Cancel"),
                        action: {showingAlert.toggle()}
                      ),
                      secondaryButton: .destructive(
                        Text("Delete"),
                        action: {
                            presentationMode.wrappedValue.dismiss()
                            if let indexToRemove = tD.activities.firstIndex(where: {$0.id == activity.id}) {
                                FirestoreService.shared.deleteActivity(activity: activity)
                                tD.activities.remove(at: indexToRemove)
                            }
                        }
                      )
                )
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
