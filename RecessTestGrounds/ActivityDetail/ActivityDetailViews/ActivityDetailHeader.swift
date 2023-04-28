//
//  ActivityDetailHeader.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import FirebaseFirestore

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
            if activity.description != "" {
                Text(activity.description)
                    .foregroundColor(Color("TextBlue"))
                    .fontWeight(.light)
                    .padding([.leading, .bottom, .trailing])
            }
            Divider().padding([.leading, .trailing])
        }
        .onAppear {
            getCreatorInfo()
        }
    }
}

extension ActivityDetailHeader {
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
}

struct ActivityDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailHeader(activity: .constant(activitiesData[0]))
    }
}
