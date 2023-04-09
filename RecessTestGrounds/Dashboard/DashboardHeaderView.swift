//
//  DashboardHeaderView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-03-30.
//

import SwiftUI

struct DashboardHeaderView: View {
    @Binding var user: User
    @Binding var showingMap: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ProfilePicView(user: $user, height: 60)
                    .padding([.leading])
                VStack(alignment: .leading) {
                    Text("Good Morning,")
                        .bold()
                    Text("\(user.getName())")
                        .modifier(PageTitle())
                }
                Spacer()
//                if showingMap {
//                    Image(systemName: "list.bullet")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .padding([.trailing], 20)
//                        .onTapGesture {
//                            showingMap.toggle()
//                        }
//                } else {
//                    Image(systemName: "map")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .padding([.trailing], 20)
//                        .onTapGesture {
//                            showingMap.toggle()
//                        }
//                }
            }
            HStack {
                Rectangle()
                    .frame(height: 10)
                .padding([.leading, .bottom, .trailing])
                NavigationLink(destination: TierView(), label: {
                    Text("Tier \(user.getTier())")
                        .bold()
                        .font(.title2)
                        .padding([.bottom, .trailing])
                })
            }
        }
        .padding([.top])
        .foregroundColor(.white)
        .background(Color("TextBlue"))
    }
}

struct DashboardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeaderView(user: .constant(TestData().currentUser), showingMap: .constant(false))
    }
}
