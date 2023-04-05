//
//  ActivityListHeader.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct ActivityListHeader: View {
    @Binding var searchText: String
    var body: some View {
        VStack {
            Text("Pick Up Games")
                .modifier(PageTitle())
            HStack {
                TextField("Search", text: $searchText)
                    .background(RoundedRectangle(cornerRadius: 10))
                    .padding()
                Image(systemName: "map")
                    .padding(.trailing)
                Image(systemName: "slider.vertical.3")
                    .padding(.trailing)
            }
        }
        .padding([.top], 60)
        .foregroundColor(.white)
        .background(Color("TextBlue"))
    }
}

struct ActivityListHeader_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListHeader(searchText: .constant(""))
    }
}
