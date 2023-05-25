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

struct ActivityDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailHeader(activity: .constant(activitiesData[0]))
    }
}
