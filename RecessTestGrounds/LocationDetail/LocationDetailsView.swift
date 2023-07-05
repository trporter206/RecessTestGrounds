//
//  LocationDetailsView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-22.
//

import SwiftUI

struct LocationDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vM = ViewModel()
    
    var exploreOnly: Bool
    @State var location: Location
    
    @Binding var activityData: Activity.Data
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                LocationHeader(location: location)
                if !exploreOnly {
                    Button(action: {
                        activityData.coordinates = [location.coordinates[0][0], location.coordinates[0][1]]
                        self.presentationMode.wrappedValue.dismiss()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ActivityButton("Save Location")
                    })
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(location.sports, id: \.self) { sport in
                            LocationSportIcon(sport: sport, noteSport: vM.noteSport)
                                .onTapGesture {
                                    vM.checkUpdateNotes(sport, location)
                                }
                                .animation(.default, value: vM.noteSport)
                        }
                    }
                    .padding(.leading)
                }
                .labelsHidden()
                CourtNotes(noteSport: vM.noteSport, noteText: vM.noteText)
                LocationActivities(location: $location)
                LocationDescription(location: location)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("TextBlue"))
        .background(.white)
    }
}

struct LocationDetailsEO: View {
    @State var noteText: String = "Temp"
    @State var noteSport: String = "Tap icon for notes"
    var location: Location
    
    func checkUpdateNotes(_ sport: String, _ location: Location) {
        guard let index = location.sports.firstIndex(of: sport) else {
            noteText = "No Notes"
            return
        }
        noteSport = location.sports[index]
        let isIndexValid = location.notes.indices.contains(index)
        if isIndexValid {
            noteText = location.notes[index]
        } else {
            noteText = ""
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                LocationHeader(location: location)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(location.sports, id: \.self) { sport in
                            LocationSportIcon(sport: sport, noteSport: noteSport)
                                .onTapGesture {
                                    checkUpdateNotes(sport, location)
                                }
                                .animation(.default, value: noteSport)
                        }
                    }
                    .padding(.leading)
                }
                .labelsHidden()
                CourtNotes(noteSport: noteSport, noteText: noteText)
                LocationDescription(location: location)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("TextBlue"))
        .background(.white)
    }
}

//struct LocationDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationDetailsView(location: mapLocations[0])
//    }
//}
