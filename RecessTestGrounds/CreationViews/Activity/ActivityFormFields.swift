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
        Text("Create New Activity")
            .font(.largeTitle)
            .foregroundColor(Color("TextBlue"))
            .padding()
        HStack {
            Text("   Sport")
            Spacer()
            Picker("Sport", selection: $activityData.sport) {
                ForEach(sportOptions, id: \.self) {
                    Text($0)
                }
            }
        }
        .modifier(FormField())
        DatePicker("   Time", selection: $activityData.date, in: Date.now...Date.now.addingTimeInterval(1209600))
            .preferredColorScheme(.dark)
            .bold()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("TextBlue"))
                .frame(height: 40))
            .padding()
        SuperTextField(placeholder: Text("   Description").foregroundColor(.white),
                       text: $activityData.description)
        .modifier(FormField())
        HStack {
            Text("   Number of Players")
            Spacer()
            Picker("Number of people", selection: $activityData.maxPlayers) {
                ForEach(1 ..< 20) {
                    Text("\($0)")
                }
            }
        }
        .modifier(FormField())
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
    }
}
