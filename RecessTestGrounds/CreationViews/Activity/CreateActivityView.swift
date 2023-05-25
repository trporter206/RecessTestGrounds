//
//  CreateActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-10.
//

import SwiftUI
import MapKit

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
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
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
            FirestoreService.shared.createActivityForLater(activity: activity)
            tD.activities.append(activity)
        } else {
            let coords = [lM.locationManager!.location!.coordinate.latitude,
                          lM.locationManager!.location!.coordinate.longitude]
            activityData.coordinates = coords
            //updatedActivity created since activity is constant and cannot be adjusted. only differences are coordinates and active status
            var updatedActivity = Activity(data: activityData, manager: tD)
            updatedActivity.id = activity.id
            updatedActivity.currentlyActive = true
            FirestoreService.shared.createActivityNow(activity: activity, coordinates: coords)
            tD.activities.append(updatedActivity)
            print("Activity ID: \(activity.id), updatedActivity ID: \(updatedActivity.id)")
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
