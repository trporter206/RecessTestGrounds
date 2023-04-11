//
//  CreateClubView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-10.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateClubView: View {
    @EnvironmentObject var tD: TestData
    @State var clubData = Club.Data()
    @State var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Create New Club")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding()
            TextField("Name", text: $clubData.name)
                .padding()
            TextField("Sport", text: $clubData.sport)
                .padding()
            TextField("Type", text: $clubData.type)
                .padding()
            TextField("Description", text: $clubData.description)
                .padding()
            Spacer()
            Button(action: {
                let club = Club(data: clubData, manager: tD)
                createClub(club: club)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.orange)
                        .frame(width: 300, height: 60)
                    Text("Create Club")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
            })
        }
    }
}

extension CreateClubView {
    func createClub(club: Club) {
        let id = UUID().uuidString
        Firestore.firestore().collection("Clubs").document(id).setData([
            "id" : id,
            "creator" : tD.currentUser.id,
            "name" : club.name,
            "sport" : club.sport,
            "members" : [],
            "upcomingActivities" : [],
            "numActivities" : 0,
            "type" : club.type,
            "description" : club.description,
        ])
        showingAlert = true
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CreateClubView_Previews: PreviewProvider {
    static var previews: some View {
        CreateClubView()
    }
}
