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
                .padding(.top)
            HStack {
                VStack(alignment: .leading) {
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
                        .onChange(of: sport) { sportValue in
                            filterActivities(sportValue, activeOnly: activeOnly)
                        }
                    }
                    HStack(spacing: 0) {
                        Text("Active Only")
                            .foregroundColor(.white)
                            .bold().padding(.trailing)
                        Toggle("", isOn: $activeOnly)
                            .labelsHidden()  // Hides the label for the Toggle, so it doesn't appear twice
                            .onChange(of: activeOnly) { _ in
                                filterActivities(sport, activeOnly: activeOnly)
                            }
                    }
                }
                .padding(.trailing)
                Spacer()
                MapButtonView(showingMap: $showingMap)
                    .padding(.leading)
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.top)
        .background(Color("TextBlue"))
        .onAppear {
            //shitty fix for deletion bug, improve eventually
            if sport == "All" && !activeOnly {
                filteredActivities = tD.activities
            }
        }
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
                    .scaleEffect(1.5)
                    .foregroundColor(.white)
                    .bold()
            } else {
                Image(systemName: "map")
                    .scaleEffect(1.5)
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
        print("Num filtered activites: \(filteredActivities.count)")
    }
}

struct ActivityFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFilterView(filteredActivities: .constant([]), showingMap: .constant(false))
    }
}
