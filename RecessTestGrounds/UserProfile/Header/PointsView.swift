//
//  PointsView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-18.
//

import SwiftUI

struct PointsView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Point System")
                .font(.largeTitle)
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
            Text("Points are a quick way for other users to get an idea of how engaged you are with the community. Earn points by hosting and joining activities. 50 points to host, with an extra 5 points per joinee. Joining other activities gets you 25 points when the activity is completed.")
                .foregroundColor(Color("TextBlue"))
                .padding(.top)
                .multilineTextAlignment(.center)
            Divider().padding([.leading, .trailing,.bottom])
            Spacer()
        }
        .background(Color("LightBlue"))
    }
}

struct PointsView_Previews: PreviewProvider {
    static var previews: some View {
        PointsView()
    }
}
