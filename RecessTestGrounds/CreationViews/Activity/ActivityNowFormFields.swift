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
        VStack {
            FieldPickerSport(title: "Sport", selection: $activityData.sport, options: sportOptions)
            SuperTextField(placeholder: Text("   Description").foregroundColor(.white),
                           text: $activityData.description)
            .modifier(FormField())
            Text("The activity will start automatically at your current location")
                .foregroundColor(.orange)
                .bold()
                .padding()
        }
    }
}

struct ActivityNowFormFields_Previews: PreviewProvider {
    static var previews: some View {
        ActivityNowFormFields(activityData: .constant(Activity.Data()))
    }
}
