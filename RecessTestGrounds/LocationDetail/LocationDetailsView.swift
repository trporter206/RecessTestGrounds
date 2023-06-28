//
//  LocationDetailsView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-06-22.
//

import SwiftUI

struct LocationDetailsView: View {
    @State var location: Location
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack(spacing: 1) {
                    Text(location.name)
                        .font(.title)
                        .bold()
                        .padding(.top)
                    Text(location.address)
                        .font(.caption)
                        .textSelection(.enabled)
                        .padding([.bottom, .horizontal])
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(Color("TextBlue"))
                Text(location.notes)
                    .padding()
                HStack {
//                    ForEach(
                }
                if location.currentActivities.count == 0 {
                    Text("No activities scheduled here")
                        .foregroundColor(.orange)
                        .bold()
                } else {
                    Text("Current scheduled activities:")
                    ForEach($location.currentActivities, id: \.self) { $activity in
                        Text($activity.wrappedValue)
                    }
                }
                if let description = location.about {
                    Text(description).padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color("TextBlue"))
        .background(.white)
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(location: mapLocations[0])
    }
}
