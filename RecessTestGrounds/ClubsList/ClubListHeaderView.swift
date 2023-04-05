//
//  ClubListHeaderView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct ClubListHeaderView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            Text("Explore Clubs")
                .modifier(PageTitle())
            HStack {
                TextField("Search", text: $searchText)
                    .border(.white, width: 2)
                    .padding()
                Image(systemName: "slider.vertical.3")
                    .padding(.trailing)
            }
        }
        .padding([.top], 60)
        .foregroundColor(.white)
        .background(Color("TextBlue"))
    }
}

struct ClubListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ClubListHeaderView(searchText: .constant(""))
    }
}
