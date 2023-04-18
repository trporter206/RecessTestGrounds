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
                ForEach($playerList.indices) { index in
                    ActivityReviewPlayerItem(playerList: $playerList,
                                             playerReviews: $playerReviews,
                                             playerIndex: index)
                }
                Spacer()
                Button(action: {
                    for (index, review) in playerReviews.enumerated() {
                        let rating = playerList[index].updateRating(review)
                        if review == 1 {
                            usersRef.document(playerList[index].id).updateData([
                                "numRatings" : FieldValue.increment(Int64(1)),
                                "positiveRatingCount" : FieldValue.increment(Int64(1)),
                                "rating" : rating
                            ])
                        } else if review == 0 {
                            usersRef.document(playerList[index].id).updateData([
                                "numRatings" : FieldValue.increment(Int64(1)),
                                "rating" : rating
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
                playerReviews = Array(repeating: 2, count: playerList.count)
            }
        }
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0]), playerList: .constant([]))
            .environmentObject(TestData())
    }
}
