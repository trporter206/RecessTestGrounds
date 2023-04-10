//
//  ActivityListView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct ActivityListView: View {
    @EnvironmentObject var lM: LocationManager
    @EnvironmentObject var tD: TestData
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                ActivityListHeader(searchText: $searchText)
                VStack(alignment: .leading) {
                    NavigationLink(destination: CreateActivityView(), label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.orange)
                                .frame(width: 300, height: 60)
                            Text("Create Activity")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                    })
                    Text("Looking for 1 more")
                        .modifier(SectionHeader())
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($tD.activities) { $activity in
                                ActivityListItem(activity: $activity)
                                    .padding(.trailing)
                            }
                        }
                        .padding()
                    }
                    Text("Activities Nearby")
                        .modifier(SectionHeader())
                    ForEach($tD.activities) {$activity in
                        ActivityListItem(activity: $activity).padding([.leading, .trailing])
                    }
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView().environmentObject(TestData())
            .environmentObject(LocationManager())
    }
}
