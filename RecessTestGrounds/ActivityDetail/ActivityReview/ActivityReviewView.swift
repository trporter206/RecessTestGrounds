//
//  ActivityReviewView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI
import FirebaseFirestore

struct ActivityReviewView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var playerList: [User]
    @State var playerReviews: [Int] = []
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let usersRef = Firestore.firestore().collection("Users")
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Activity Review")
                    .bold()
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("TextBlue"))
                Text("Duration: ")
                    .padding()
                Text("Players")
                ForEach($playerList.filter({$0.id != tD.currentUser.id}).indices) { index in
                    ActivityReviewPlayerItem(playerList: $playerList,
                                             playerReviews: $playerReviews,
                                             playerIndex: index)
                }
                Spacer()
                Button(action: {
                    closeOutActivity()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.orange)
                            .frame(width: 300, height: 60)
                        Text("Submit")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                })
            }
            .background(Color("LightBlue"))
            .onAppear {
                playerReviews = Array(repeating: 2, count: playerList.count-1)
            }
        }
    }
}

extension ActivityReviewView {
    func closeOutActivity() {
        let points = 50 + ((playerList.count - 1) * 5)
        tD.currentUser.addPoints(points)
        for (index, review) in playerReviews.enumerated() {
            let rating = playerList[index].updateRating(review)
            usersRef.document(playerList[index].id).updateData(["points" : FieldValue.increment(Int64(25))])
            usersRef.document(playerList[index].id).updateData(["rating" : rating])
            if review == 1 {
                usersRef.document(playerList[index].id).updateData([
                    "numRatings" : FieldValue.increment(Int64(1)),
                    "positiveRatingCount" : FieldValue.increment(Int64(1)),
                ])
            } else if review == 0 {
                usersRef.document(playerList[index].id).updateData([
                    "numRatings" : FieldValue.increment(Int64(1)),
                ])
            }
        }
        dismiss()
        presentationMode.wrappedValue.dismiss()
        Firestore.firestore().collection("Activities").document(activity.id).delete() { error in
            if let error = error {
                print("Error deleting document: \(error)")
            }
        }
        tD.activities.removeAll(where: {$0.id == activity.id})
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0]), playerList: .constant([]))
            .environmentObject(TestData())
    }
}
