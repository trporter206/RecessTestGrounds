//
//  CreateActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-10.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateActivityView: View {
    @EnvironmentObject var tD: TestData
    @State var activityData = Activity.Data()
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Create New Activity")
                .font(.largeTitle)
                .padding()
            TextField("Sport", text: $activityData.sport)
                .padding()
            DatePicker("Time", selection: $activityData.date, in: Date.now...Date.now.addingTimeInterval(1209600))
                .padding()
            TextField("Description", text: $activityData.description)
                .padding()
            Picker("Number of people", selection: $activityData.maxPlayers) {
                ForEach(1 ..< 20) {
                    Text("\($0)")
                }
            }.padding()
            Button(action: {
                let activity = Activity(data: activityData, manager: tD)
                createActivity(activity: activity)
            }, label: {
                Text("Create Activity")
            })
            .alert("Activity Created", isPresented: $showingAlert) {
                Button("OK", role: .cancel){}
            }
        }
    }
}

extension CreateActivityView {
    func createActivity(activity: Activity) {
        let id = UUID().uuidString
        Firestore.firestore().collection("Activities").document(id).setData([
            "id" : id,
            "points" : 50,
            "sport" : activity.sport,
            "maxPlayers" : activity.maxPlayers,
            "playerCount" : 1,
            "date" : activity.date,
            "description" : activity.description,
            "creator" : tD.currentUser.id,
            "players" : [tD.currentUser.id],
            "coordinates" : activity.coordinates,
            "currentlyActive" : false
        ])
        showingAlert = true
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView()
    }
}
