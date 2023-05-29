//
//  ActivityReviewView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ActivityReviewView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activity: Activity
    @Binding var playerList: [User]
    @StateObject var vM = ViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Activity Review")
                .bold()
                .font(.system(size: 36))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color("TextBlue"))
            ActivityReviewPlayerList(playerList: $playerList, playerReviews: $vM.playerReviews)
            Spacer()
            ActivityReviewSubmitButton(action: {closeOutActivity(vM)})
        }
        .background(Color("LightBlue"))
        .onAppear {
            vM.playerReviews = Array(repeating: 2, count: playerList.count-1)
        }
    }
}

struct ActivityReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityReviewView(activity: .constant(TestData().activities[0]), playerList: .constant([]))
            .environmentObject(TestData())
    }
}
