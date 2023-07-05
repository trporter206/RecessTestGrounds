//
//  LocationDetails-VM.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-07-05.
//

import Foundation
import SwiftUI

extension LocationDetailsView {
    @MainActor class ViewModel: ObservableObject {
        @Published var noteText: String = "Temp"
        @Published var noteSport: String = "Tap icon for notes"
        
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
    }
}

struct LocationHeader: View {
    var location: Location
    
    var body: some View {
        HStack {
            Image(systemName: "leaf")
                .resizable() // Makes the image resizable
                .scaledToFit()
                .frame(width: 20, height: 20)
                .bold()
                .foregroundColor(.orange)
                .padding()
                .background(Circle()
                    .fill(.white)
                    .shadow(radius: 1))
                .padding(.trailing)
            VStack(alignment: .leading, spacing: 1) {
                Text(location.name)
                    .font(.title)
                    .bold()
                    .padding(.top)
                Text(location.address)
                    .font(.caption)
                    .textSelection(.enabled)
                    .padding([.bottom])
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color("TextBlue"))
    }
}

struct LocationSportIcon: View {
    var sport: String
    var noteSport: String
    
    var body: some View {
        Image(systemName: "figure.\(sport.lowercased())")
            .resizable() // Makes the image resizable
            .scaledToFit()
            .frame(width: 30, height: 30)
            .bold()
            .foregroundColor(noteSport == sport ? .orange : .white)
            .padding()
            .background(Circle()
                .fill(Color("TextBlue"))
                .shadow(radius: 1))
            .padding([.top, .trailing])
    }
}

struct CourtNotes: View {
    var noteSport: String
    var noteText: String
    
    var body: some View {
        VStack {
            Text(noteSport)
                .font(.title3)
                .bold()
                .padding(.top)
            if noteText != "Temp" {
                Text(noteText == "" ? "No Notes" : noteText)
                    .bold()
                    .padding(.horizontal)
            }
        }
    }
}

struct LocationActivities: View {
    @Binding var location: Location
    
    var body: some View {
        if location.currentActivities.count == 0 {
            Text("No activities scheduled here")
                .foregroundColor(.orange)
                .bold()
                .padding()
        } else {
            Text("Current scheduled activities:")
            ForEach($location.currentActivities, id: \.self) { $activity in
                Text($activity.wrappedValue)
            }
        }
    }
}

struct LocationDescription: View {
    var location: Location
    
    var body: some View {
        if let description = location.about {
            Text(description).padding()
        } else {
            EmptyView()
        }
    }
}
