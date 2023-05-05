//
//  ActivityNowFormFields.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-03.
//

import SwiftUI

struct ActivityNowFormFields: View {
    @Binding var activityData: Activity.Data
    
    var body: some View {
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
        SuperTextField(placeholder: Text("   Description").foregroundColor(.white),
                       text: $activityData.description)
        .modifier(FormField())
    }
}

struct ActivityNowFormFields_Previews: PreviewProvider {
    static var previews: some View {
        ActivityNowFormFields(activityData: .constant(Activity.Data()))
    }
}
