//
//  TierHeaderView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import SwiftUI

struct TierHeaderView: View {
    var body: some View {
        Text("Tier Structure")
            .font(.largeTitle)
            .foregroundColor(Color("TextBlue"))
            .padding(.top)
        Text("Starting at Tier 5 going to Tier 1, player Tiers are a measure of how active players are in the community. Improving Tiers comes with real world perks and bonuses ")
            .foregroundColor(Color("TextBlue"))
            .padding(.top)
            .multilineTextAlignment(.center)
        Divider().padding([.leading, .trailing,.bottom])
    }
}

struct TierHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TierHeaderView()
    }
}
