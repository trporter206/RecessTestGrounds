//
//  ActivityFilterView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-23.
//

import SwiftUI

struct ActivityFilterView: View {
    @EnvironmentObject var tD: TestData
    @Binding var filteredActivities: [Activity]
    @Binding var showingMap: Bool
    @State var sport = "All"
    @State var activeOnly = false
    
    var body: some View {
        VStack {
            Text("Activities")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding()
            HStack {
                Text("Sport")
                    .foregroundColor(.white)
                    .bold()
                Picker("Sport", selection: $sport) {
                    Text("All").tag("All")
                    ForEach(sportOptions, id: \.self) {
                        Text($0)
                    }
                }
                .padding(.trailing)
                .onChange(of: sport) { sportValue in
                    filterActivities(sportValue, activeOnly: activeOnly)
                }
                Spacer()
                Toggle("Active Only", isOn: $activeOnly)
                    .foregroundColor(.white)
                    .bold()
                    .onChange(of: activeOnly) { _ in
                        filterActivities(sport, activeOnly: activeOnly)
                    }
                Spacer()
                MapButtonView(showingMap: $showingMap)
            }
            .padding()
        }
        .background(Color("TextBlue"))
    }
}

struct MapButtonView: View {
    @Binding var showingMap: Bool
    
    var body: some View {
        Button(action: {
            showingMap.toggle()
        }, label: {
            if showingMap {
                Image(systemName: "list.bullet")
                    .foregroundColor(.white)
                    .bold()
            } else {
                Image(systemName: "map")
                    .foregroundColor(.white)
                    .bold()
            }
        })
        .padding(.leading)
    }
}

extension ActivityFilterView {
    func filterActivities(_ sport: String, activeOnly: Bool) {
        var activities = tD.activities

        if sport != "All" {
            activities = activities.filter({$0.sport == sport})
        }

        if activeOnly {
            activities = activities.filter({$0.currentlyActive})
        }

        filteredActivities = activities
    }
}

struct ActivityFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterView(filteredActivities: .constant([]), showingMap: .constant(false))
    }
}
