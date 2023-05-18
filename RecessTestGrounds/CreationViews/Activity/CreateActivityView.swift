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
    @State var activityType = "Now"
    @State private var showingAlert = false
    @State var addressText = ""
    @State var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    @State var coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var body: some View {
        VStack {
            HeaderText(title: "Create New Activity")
            Picker("Start Now or Later", selection: $activityType) {
                Text("Now").tag("Now")
                Text("Later").tag("Later")
            }.pickerStyle(.segmented)
            if activityType == "Now" {
                ActivityNowFormFields(activityData: $activityData)
            } else {
                ActivityFormFields(activityData: $activityData)
            }
            Spacer()
            ErrorMessageText(errorMessage: $errorMessage)
            CreateActivityButton(activityData: $activityData,
                                 showingAlert: $showingAlert,
                                 errorMessage: $errorMessage,
                                 activityType: $activityType)
        }
        .background(Color("LightBlue"))
        .onAppear {
            guard let lat = lM.locationManager?.location?.coordinate.latitude else { return }
            let lon = lM.locationManager!.location!.coordinate.longitude
            coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
}

struct HeaderText: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .foregroundColor(Color("TextBlue"))
            .padding()
    }
}

struct CreateActivityButton: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @Binding var activityData: Activity.Data
    @Binding var showingAlert: Bool
    @Binding var errorMessage: String
    @Binding var activityType: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
        }
        
        if activityType == "Later" {
            if activityData.coordinates == [0.0, 0.0] {
                print("Bad coords")
                return false
            }
        }
        return true
    }
    
    func createActivity(activity: Activity) {
        if activityType == "Later" {
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
        } else {
            let coords = [lM.locationManager!.location!.coordinate.latitude,
                          lM.locationManager!.location!.coordinate.longitude]
            activityData.coordinates = coords
            var updatedActivity = Activity(data: activityData, manager: tD)
            updatedActivity.id = activity.id
            updatedActivity.currentlyActive = true
            Firestore.firestore().collection("Activities").document(activity.id).setData([
                "id" : activity.id,
                "points" : 50,
                "sport" : activity.sport,
                "maxPlayers" : activity.maxPlayers,
                "playerCount" : 1,
                "date" : Date.now,
                "description" : activity.description,
                "creator" : activity.creator,
                "players" : [activity.creator],
                "coordinates" : coords,
                "currentlyActive" : true
            ])
            tD.activities.append(updatedActivity)
        }
        showingAlert = true
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct CreateActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            CreateActivityView()
//                .environmentObject(TestData())
//                .environmentObject(LocationManager())
//        }
//    }
//}
