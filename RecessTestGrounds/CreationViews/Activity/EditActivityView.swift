//
//  EditActivityView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-25.
//

import SwiftUI

struct EditActivityView: View {
    @EnvironmentObject var tD: TestData
    @Binding var activityData: Activity.Data
    var id: String
    
    var body: some View {
        VStack {
            HeaderText(title: "Edit Activity")
            VStack {
                SuperTextField(placeholder: Text("   Title (optional)"), text: $activityData.title)
                    .modifier(FormField())
                FieldPickerSport(title: "Sport", selection: $activityData.sport, options: sportOptions)
                DatePickerField(title: "Time", selection: $activityData.date)
                SuperTextField(placeholder: Text("   Description (optional)"), text: $activityData.description)
                    .modifier(FormField())
                ChooseLocationLink(activityData: $activityData)
            }
            Spacer()
            UpdateActivityButton(activityData: $activityData, id: id).environmentObject(tD)
        }
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
            var newActivity = Activity(data: activityData, idString: id, manager: tD)
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

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityView(activityData: .constant(activitiesData[0].data), id: "")
    }
}
