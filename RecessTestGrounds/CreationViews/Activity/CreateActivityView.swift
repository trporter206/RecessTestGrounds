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
    @Environment(\.presentationMode) var presentationMode
    
    @State var coords = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var body: some View {
        VStack {
            Text("Create New Activity")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding()
            TextField("Sport", text: $activityData.sport)
                .padding()
            DatePicker("Time", selection: $activityData.date, in: Date.now...Date.now.addingTimeInterval(1209600))
                .padding()
            TextField("Description", text: $activityData.description)
                .padding()
            HStack {
                Text("Number of Players")
                Spacer()
                Picker("Number of people", selection: $activityData.maxPlayers) {
                    ForEach(1 ..< 20) {
                        Text("\($0)")
                    }
                }
            }
            .padding()
            NavigationLink(destination: ActivityChooseLocalMap(addressText: $addressText, activityData: $activityData), label: {
                Text("Choose Location")
            })
            Text("Location address: \(addressText)")
            Spacer()
            Button(action: {
                let activity = Activity(data: activityData, manager: tD)
                createActivity(activity: activity)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.orange)
                        .frame(width: 300, height: 60)
                    Text("Create Activity")
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
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
        NavigationView {
            CreateActivityView().environmentObject(TestData()).environmentObject(LocationManager())
        }
    }
}
