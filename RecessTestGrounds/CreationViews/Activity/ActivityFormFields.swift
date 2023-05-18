//
//  ActivityFormFields.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI

struct ActivityFormFields: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activityData: Activity.Data
    
    var body: some View {
        VStack {
            FieldPickerSport(title: "Sport", selection: $activityData.sport, options: sportOptions)
            DatePickerField(title: "Time", selection: $activityData.date)
            SuperTextField(placeholder: Text("   Description"), text: $activityData.description)
                .modifier(FormField())
            ChooseLocationLink(activityData: $activityData)
        }
        .background(Color("LightBlue"))
    }
}

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

struct ChooseLocationLink: View {
    @EnvironmentObject var lM: LocationManager
    @Binding var activityData: Activity.Data
    var body: some View {
        NavigationLink(destination: ActivityChooseLocalMap(activityData: $activityData).environmentObject(lM), label: {
            Text("Choose Location         ")
                .bold()
                .foregroundColor(.orange)
                .background(RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color("TextBlue"))
                    .frame(height: 40))
                .padding()
        })
    }
}

struct ActivityFormFields_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFormFields(activityData: .constant(Activity.Data()))
            .environmentObject(LocationManager())
    }
}
