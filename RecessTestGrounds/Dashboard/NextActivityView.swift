//
//  NextActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-29.
//

import SwiftUI
import FirebaseFirestore

struct NextActivityView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @State var userInfo: User? = nil
    @State var profileStrings: [String] = []
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: $activity).environmentObject(lM)
            .environmentObject(tD), label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .frame(height: 350)
                    .padding()
                    .shadow(radius: 1)
                VStack (alignment: .leading) {
                    HStack(alignment: .center) {
                        if let user = userInfo {
                            ZStack(alignment: .bottomTrailing) {
                                ProfilePicView(profileString: user.profilePicString, height: 90)
                                ProfilePointsLink(user: user)
                            }.padding(.horizontal)
                        } else {
                            EmptyView()
                        }
                        NextActivityHeaderInfo(activity: activity, userInfo: userInfo)
                    }
                    NextActivityPlayerList(activity: activity, profileStrings: profileStrings)
                    Text(activity.description).padding()
                }.padding(.horizontal)
            }
            .foregroundColor(Color("TextBlue"))
        })
        .onAppear {
            guard tD.activities.contains(where: { $0.id == activity.id }) else {
                return
            }
            FirestoreService.shared.getUserInfo(id: activity.creator) {
                result in
                switch result {
                case .success(let user):
                    userInfo = user
                case .failure(let error):
                    print("Error decoding creator info: \(error)")
                }
            }
            profileStrings = FirestoreService.shared.getProfileStrings(tD: tD, activity: activity)
        }
    }
}

struct NextActivityHeaderInfo: View {
    var activity: Activity
    var userInfo: User?
    
    var body: some View {
        VStack (alignment: .leading) {
            if activity.title != "" {
                VStack(alignment: .leading) {
                    Text(activity.title)
                        .lineLimit(1)
                        .bold()
                        .font(.title)
                    Text(activity.sport).bold()
                }
            } else {
                Text(activity.sport).bold().font(.title)
            }
            if let name = userInfo?.name {
                Text("Hosted by \(name)").fontWeight(.light)
            }
            Divider()
            HStack {
                Spacer()
                Text(activity.date.formatted()).fontWeight(.light)
            }
        }.padding(.trailing)
    }
}

struct NextActivityPlayerList: View {
    var activity: Activity
    var profileStrings: [String]
    
    var body: some View {
        Text("\(activity.players.count) Players").bold().padding(.leading)
        ScrollView(.horizontal) {
            HStack {
                ForEach(profileStrings, id: \.self) { str in
                    ProfilePicView(profileString: str, height: 60)
                }
            }.padding(.horizontal)
        }
    }
}

//struct NextActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        NextActivityView(activity: .constant(activitiesData[0]))
//            .environmentObject(LocationManager())
//            .environmentObject(TestData())
//    }
//}
