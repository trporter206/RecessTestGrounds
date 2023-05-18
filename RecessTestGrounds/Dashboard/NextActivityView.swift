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
                    HStack {
                        ZStack(alignment: .bottomTrailing) {
                            if let user = userInfo {
                                ProfilePicView(profileString: user.profilePicString, height: 90)
                                ProfilePointsLink(user: user)
                            } else {
                                EmptyView()
                            }
                        }
                        .padding([.leading, .trailing])
                        NextActivityHeaderInfo(activity: activity)
                    }
                    NextActivityPlayerList(activity: activity, profileStrings: profileStrings)
                    Text(activity.description).padding()
                }.padding()
            }
            .foregroundColor(Color("TextBlue"))
        })
        .onAppear {
            getCreatorInfo()
            getProfileStrings()
        }
    }
}

struct NextActivityHeaderInfo: View {
    var activity: Activity
    var userInfo: User?
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(activity.sport).bold().font(.title)
            if let name = userInfo?.getName() {
                Text("Hosted by \(name)")
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
        Text("\(activity.playerCount) Players").bold().padding([.leading, .top])
        ScrollView(.horizontal) {
            HStack {
                ForEach(profileStrings, id: \.self) { str in
                    ProfilePicView(profileString: str, height: 60)
                }
            }.padding([.leading, .trailing])
        }
    }
}

extension NextActivityView {
    func getProfileStrings() {
        guard let activityIndex = tD.activities.firstIndex(where: { $0.id == activity.id }) else {
            return
        }
        profileStrings = []
        for player in tD.activities[activityIndex].players {
            Firestore.firestore().collection("Users").document(player).getDocument() { documentSnapshot, error in
                if let error = error {
                    print("Erro getting creator info \(error)")
                } else {
                    do {
                        let user = try documentSnapshot!.data(as: User.self)
                        profileStrings.append(user.profilePicString)
                    } catch {
                        print("Erro decoding creator info \(error)")
                    }
                }
            }
        }
    }

    
    func getCreatorInfo() {
        guard let activityIndex = tD.activities.firstIndex(where: { $0.id == activity.id }) else {
            return
        }
        
        Firestore.firestore().collection("Users").document(tD.activities[activityIndex].creator).getDocument() { documentSnapshot, error in
            if let error = error {
                print("Erro getting creator info \(error)")
            } else {
                do {
                    let user = try documentSnapshot!.data(as: User.self)
                    userInfo = user
                } catch {
                    print("Erro decoding creator info \(error)")
                }
            }
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
