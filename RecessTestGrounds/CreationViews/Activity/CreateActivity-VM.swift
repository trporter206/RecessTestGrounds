//
//  CreateActivity-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-28.
//

import Foundation
import SwiftUI
import MapKit

extension CreateActivityView {
    @MainActor class ViewModel: ObservableObject {
        @Published var activityData = Activity.Data()
        @Published var activityType = "Now"
        @Published var showingAlert = false
        @Published var addressText = ""
        @Published var errorMessage = ""
        @Published var id: String = ""
        @Published var coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
}

//Views: CreateActivityView, EditActivityView
//Func: Display page title
struct HeaderText: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .foregroundColor(Color("TextBlue"))
            .padding()
    }
}

//View: CreateActivityView
//Func: Save user input data as new activity in firebase
//Navigation: dismiss to dashboard
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


//View: CreateActivityView
//Func: Display necessary fields depending on activityType
struct ActivityFormFields: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activityData: Activity.Data
    @Binding var activityType: String
    
    @State var locationName = ""
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Title (optional)"), text: $activityData.title)
                .modifier(FormField())
            FieldPickerSport(title: "Sport", selection: $activityData.sport, options: sportOptions)
            SuperTextField(placeholder: Text("   Description (optional)"), text: $activityData.description)
                .modifier(FormField())
            if activityType == "Later" {
                DatePickerField(title: "Time", selection: $activityData.date)
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    .animation(.easeIn, value: activityType)
                if locationName != "" {
                    Text(locationName)
                        .foregroundColor(Color("TextBlue"))
                        .font(.title2)
                        .bold()
                        .padding()
                }
                ChooseLocationLink(activityData: $activityData, locationName: $locationName)
                    .transition(.opacity)
                    .animation(.easeIn, value: activityType)
            } else {
                Text("The activity will start automatically at your current location")
                    .foregroundColor(.orange)
                    .bold()
                    .padding()
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                    .animation(.easeIn, value: activityType)
            }
        }
    }
}

//View: EditActivityView
//Func: Show the field for pickinhg activity sport
struct FieldPickerSport: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    var body: some View {
        HStack {
            Text("   \(title)")
            Spacer()
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
        }
        .modifier(FormField())
    }
}

//View: EditActivityView
//Func: display date picker for activity
struct DatePickerField: View {
    let title: String
    @Binding var selection: Date
    var body: some View {
        DatePicker("   \(title)", selection: $selection, in: Date.now...Date.now.addingTimeInterval(1209600))
            .preferredColorScheme(.dark)
            .bold()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("TextBlue"))
                .frame(height: 40))
            .padding()
    }
}

//View: EditActivityView
//Func: button that navigates to location picker map view
struct ChooseLocationLink: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activityData: Activity.Data
    @Binding var locationName: String
    var body: some View {
        NavigationLink(destination: ActivityChooseLocalMap(activityData: $activityData, sport: $activityData.sport, locationName: $locationName).environmentObject(lM), label: {
            Text(locationName == "" ? "Choose Location" : "Change Location")
                .bold()
                .foregroundColor(.orange)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("TextBlue"))
                    .frame(height: 40))
                .padding()
        })
    }
}

struct UpdateActivityButton: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tD: TestData
    @State var showingAlert: Bool = false
    @Binding var activityData: Activity.Data
    var id: String
    
    var body: some View {
        Button(action: {
            FirestoreService.shared.updateActivity(data: activityData, id: id)
            showingAlert.toggle()
            let newActivity = Activity(data: activityData, idString: id, manager: tD)
            if let newActivityIndex = tD.activities.firstIndex(where: {$0.id == id}) {
                tD.activities[newActivityIndex] = newActivity
            }
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            ActivityButton("Update Info")
        }).alert("Activity Updated", isPresented: $showingAlert) {
            Button("OK", role: .cancel){}
        }
    }
}
