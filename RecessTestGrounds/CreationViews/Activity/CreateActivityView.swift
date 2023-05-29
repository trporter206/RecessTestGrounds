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
    @StateObject private var vM = ViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HeaderText(title: "Create New Activity")
            Picker("Start Now or Later", selection: $vM.activityType.animation()) {
                Text("Now").tag("Now")
                Text("Later").tag("Later")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            ActivityFormFields(activityData: $vM.activityData, activityType: $vM.activityType)
            Spacer()
            ErrorMessageText(errorMessage: $vM.errorMessage)
            CreateActivityButton(activityData: $vM.activityData,
                                 showingAlert: $vM.showingAlert,
                                 errorMessage: $vM.errorMessage,
                                 activityType: $vM.activityType)
        }
        .background(Color("LightBlue"))
        .onAppear {
            guard let lat = lM.locationManager?.location?.coordinate.latitude else { return }
            let lon = lM.locationManager!.location!.coordinate.longitude
            vM.coords = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
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
