//
//  ActivityDetail-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-28.
//

import Foundation
import SwiftUI
import CoreLocation

extension ActivityDetailView {
    @MainActor class ViewModel: ObservableObject {
        @Published var userInfo: User = usersData[0]
        @Published var playerlist: [User] = []
        @Published var showingReviewSheet = false
        @Published var showingAlert = false 
    }
    
    func onAppear(_ activity: Activity, _ vM: ViewModel) {
        FirestoreService.shared.getUserInfo(id: activity.creator) {
            result in
            switch result {
            case .success(let user):
                vM.userInfo = user
            case .failure(let error):
                print("Error decoding creator info: \(error)")
            }
        }
        vM.playerlist = []
        for id in activity.players {
            FirestoreService.shared.getUserInfo(id: id) {result in
                switch result {
                case .success(let user):
                    vM.playerlist.append(user)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct PlayerProfileLink: View {
    @EnvironmentObject var tD: TestData
    var activity: Activity
    @Binding var userInfo: User
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayerProfile(player: $userInfo).environmentObject(tD), label: {
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
    @EnvironmentObject var tD: TestData
    @Binding var playerList: [User]
    
    var body: some View {
        Text("Players (\($playerList.count))")
            .foregroundColor(Color("TextBlue"))
        ScrollView(.horizontal) {
            HStack {
                ForEach($playerList) { $player in
                    NavigationLink(destination: PlayerProfile(player: $player).environmentObject(tD), label: {
                        VStack {
                            ProfilePicView(profileString: $player.wrappedValue.profilePicString, height: 60)
                            Text(player.name).font(.footnote)
                        }
                    })
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

struct ActivityActionButtonView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    @State var joined = false
    @Binding var playerList: [User]
    @Binding var showingReview: Bool
    
    var body: some View {
        VStack {
            if $tD.currentUser.id == activity.creator {
                if activity.currentlyActive {
                    EndActivityButton(showingReview: $showingReview)
                } else {
                    StartActivityButton(activity: $activity)
                }
            } else {
                if joined {
                    LeaveActivityButton(joined: $joined, activity: $activity, playerList: $playerList)
                } else {
                    JoinActivityButton(joined: $joined, activity: $activity, playerList: $playerList)
                }
            }
        }
        .onAppear {
            if activity.players.contains(tD.currentUser.id) {
                joined = true
            } else {
                joined = false
            }
        }
    }
}

struct EndActivityButton: View {
    @Binding var showingReview: Bool
    
    var body: some View {
        Button(action: {
            showingReview.toggle()
        }, label: {
            ActivityButton("End Activity")
        })
    }
}

struct StartActivityButton: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activity: Activity
    
    var body: some View {
        if distanceToMeters(activity: $activity) > 100 {
            Text("You must be within 100 meters of your activity to start")
                .bold()
                .foregroundColor(.orange)
                .padding()
        } else {
            Button(action: {
                activity.currentlyActive = true
                FirestoreService.shared.makeActivityActive(activity: activity)
            }, label: {
                ActivityButton("Start Activity")
            })
        }
    }
    
    func distanceToMeters(activity: Binding<Activity>) -> Double {
        let distance = lM.locationManager?.location?
            .distance(from:
                        CLLocation(latitude: activity.wrappedValue.coordinates[0],
                                   longitude: activity.wrappedValue.coordinates[1]))
        guard distance != nil else {
            return 0.0
        }
        return distance!
    }
}

struct LeaveActivityButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var joined: Bool
    @Binding var activity: Activity
    @Binding var playerList: [User]
    
    var body: some View {
        Button(action: {
            removePlayer()
            joined = false
        }, label: {
            ActivityButton("Leave Activity")
        })
    }
    
    func removePlayer() {
        activity.removePlayer(tD.currentUser)
        playerList.removeAll(where: {$0.id == tD.currentUser.id})
        FirestoreService.shared.removePlayer(activity: activity, user: tD.currentUser)
    }
}

struct JoinActivityButton: View {
    @EnvironmentObject var tD: TestData
    @Binding var joined: Bool
    @Binding var activity: Activity
    @Binding var playerList: [User]
    
    var body: some View {
        Button(action: {
            addPlayer()
            joined = true
        }, label: {
            ActivityButton("Join Activity")
        })
    }
    
    func addPlayer() {
        activity.addPlayer(tD.currentUser) //maintain info when leaving view
        playerList.append(tD.currentUser)  //update view on click
        FirestoreService.shared.addPlayer(activity: activity, user: tD.currentUser)
    }
}

struct ActivityDetailHeader: View {
    @Binding var activity: Activity
    @State var userInfo: User = usersData[0]
    
    var body: some View {
        VStack {
            HStack {
                ProfilePicView(profileString: userInfo.profilePicString, height: 90)
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
        }
    }
}
