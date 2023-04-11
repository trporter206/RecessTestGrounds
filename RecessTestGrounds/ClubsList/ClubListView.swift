//
//  ClubListView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct ClubListView: View {
    @EnvironmentObject var tD: TestData
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                ClubListHeaderView(searchText: $searchText)
                VStack(alignment: .leading) {
                    NavigationLink(destination: CreateClubView(), label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundColor(.orange)
                                .frame(width: 300, height: 60)
                            Text("Create Club")
                                .foregroundColor(.white)
                                .bold()
                        }
                        .padding()
                    })
                    Text("Featured Club")
                        .modifier(SectionHeader())
                    ClubListItem(club: $tD.clubs[0])
                        .padding([.leading, .trailing])
                    Text("Locally active clubs")
                        .modifier(SectionHeader())
                    ForEach($tD.clubs) {$club in
                        ClubListItem(club: $club)
                            .padding([.leading, .trailing])
                    }
                }
            }
            .background(Color("LightBlue"))
        }
    }
}

struct ClubListView_Previews: PreviewProvider {
    static var previews: some View {
        ClubListView().environmentObject(TestData())
    }
}
