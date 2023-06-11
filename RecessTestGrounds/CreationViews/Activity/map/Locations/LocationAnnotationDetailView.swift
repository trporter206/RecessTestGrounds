//
//  LocationAnnotationDetailView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-11.
//

import SwiftUI

struct LocationAnnotationDetailView: View {
    @Binding var activityData: Activity.Data
    var location: Binding<Location>
    var lm: LocationManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text(location.wrappedValue.sport)
            Text(location.wrappedValue.notes)
            Button(action: {
                activityData.coordinates = [location.wrappedValue.coordinates[0], location.wrappedValue.coordinates[1]]
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Choose Location")
                    .foregroundColor(.orange)
                    .background(RoundedRectangle(cornerRadius: 50))
            })
        }
    }
}

//struct LocationAnnotationDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationAnnotationDetailView()
//    }
//}
