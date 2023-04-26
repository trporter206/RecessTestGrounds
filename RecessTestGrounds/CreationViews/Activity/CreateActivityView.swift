//
//  CreateActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-10.
//

import SwiftUI
import MapKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateActivityView: View {
    @EnvironmentObject var tD: TestData
    @EnvironmentObject var lM: LocationManager
    @State var activityData = Activity.Data()
    @State private var showingAlert = false
    @State var addressText = ""
    @State var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State var coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var body: some View {
        VStack {
            ActivityFormFields(activityData: $activityData)
            Spacer()
            Text(errorMessage)
                .bold()
                .foregroundColor(.orange)
            Button(action: {
                if inputsAreValid() {
                    let activity = Activity(data: activityData, manager: tD)
                    createActivity(activity: activity)
                } else {
                    errorMessage = "Make sure all fields are filled"
                }
            }, label: {
                ActivityButton("Create Activity")
            })
            .alert("Activity Created", isPresented: $showingAlert) {
                Button("OK", role: .cancel){}
            }
        }
        .background(Color("LightBlue"))
        .onAppear {
            coords = CLLocationCoordinate2D(latitude: activityData.coordinates[0], longitude: activityData.coordinates[1])
        }
    }
}

extension CreateActivityView {
    func inputsAreValid() -> Bool {
        if activityData.sport == "" {
            print("Empty Sport")
            return false
        } else if (activityData.maxPlayers == 0) {
            print("0 players")
            return false
        } else if (activityData.description == "") {
            print("Empty desc")
            return false
        } else if activityData.coordinates == [0.0, 0.0] {
            print("Bad coords")
            return false
        }
        return true
    }
    
    func addressTextState() -> String {
        if addressText == "" {
            return "Address will show here"
        }
        return addressText
    }
    
    func createActivity(activity: Activity) {
//        let id = UUID().uuidString
        Firestore.firestore().collection("Activities").document(activity.id).setData([
            "id" : activity.id,
            "points" : 50,
            "sport" : activity.sport,
            "maxPlayers" : activity.maxPlayers,
            "playerCount" : 1,
            "date" : activity.date,
            "description" : activity.description,
            "creator" : activity.creator,
            "players" : [activity.creator],
            "coordinates" : activity.coordinates,
            "currentlyActive" : false
        ])
        tD.activities.append(activity)
        showingAlert = true
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateActivityView()
                .environmentObject(TestData())
                .environmentObject(LocationManager())
        }
    }
}
