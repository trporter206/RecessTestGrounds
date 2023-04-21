//
//  TierView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-01.
//

import SwiftUI

struct TierView: View {
    var body: some View {
        ScrollView(.vertical) {
            TierHeaderView()
            VStack(alignment: .leading) {
                Text("Tier 5")
                    .modifier(TierTitle())
                Text("- Has joined and hosted at least 1 activity each.")
                    .modifier(TierText())
                Text("- At least 100 points")
                    .modifier(TierText())
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Tier 4")
                    .modifier(TierTitle())
                Text("- Has joined and hosted at least 5 activities each.")
                    .modifier(TierText())
                Text("- At least 200 points.")
                    .modifier(TierText())
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Tier 3")
                    .modifier(TierTitle())
                Text("- Has joined and hosted at least 10 activities each.")
                    .modifier(TierText())
                Text("- At least 500 points")
                    .modifier(TierText())
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Tier 2")
                    .modifier(TierTitle())
                Text("- Has joined and hosted at least 20 activities each.")
                    .modifier(TierText())
                Text("- At least 800 points")
                    .modifier(TierText())
            }.padding(.bottom)
            VStack(alignment: .leading) {
                Text("Tier 1")
                    .modifier(TierTitle())
                Text("- Has joined and hosted at least 30 activities each.")
                    .modifier(TierText())
                Text("- At least 1200 points")
                    .modifier(TierText())
            }.padding(.bottom)
        }
        .background(Color("LightBlue"))
        .padding()
    }
}

struct TierView_Previews: PreviewProvider {
    static var previews: some View {
        TierView()
    }
}
