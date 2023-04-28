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
    @State var userInfo: User = usersData[0]
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
                            ProfilePicView(profileString: userInfo.profilePicString, height: 90)
                            Text("\(userInfo.points)")
                                .foregroundColor(.orange)
                                .fontWeight(.heavy)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 50)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1))
                        }
                        .padding([.leading, .trailing])
                        VStack (alignment: .leading) {
                            Text(activity.sport).bold().font(.title)
                            Text("Hosted by \(userInfo.getName())")
                            Divider()
                            HStack {
                                Spacer()
                                Text(activity.date.formatted()).fontWeight(.light)
                            }
                        }.padding(.trailing)
                    }
                    Text("\(activity.playerCount)/\(activity.maxPlayers) Players").bold().padding([.leading, .top])
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(profileStrings, id: \.self) { str in
                                ProfilePicView(profileString: str, height: 60)
                            }
                        }.padding([.leading, .trailing])
                    }
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

extension NextActivityView {
    func getProfileStrings() {
        profileStrings = []
        for player in activity.players {
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
        Firestore.firestore().collection("Users").document(activity.creator).getDocument() { documentSnapshot, error in
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

struct NextActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NextActivityView(activity: .constant(activitiesData[0]))
            .environmentObject(LocationManager())
            .environmentObject(TestData())
    }
}
