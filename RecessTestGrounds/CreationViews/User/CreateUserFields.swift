//
//  CreateUserFields.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-02.
//

import SwiftUI

struct CreateUserFields: View {
    @Binding var userData: User.Data
    @Binding var password: String
    @Binding var chosenAvatar: String
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Name").foregroundColor(.white),
                           text: $userData.name)
            .modifier(FormField())
            SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                           text: $userData.email)
            .modifier(FormField())
            SuperTextField(placeholder: Text("   Password").foregroundColor(.white),
                           text: $password)
            .modifier(FormField())
            Text("Choose an Avatar")
                .modifier(SectionHeader())
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0...avatarStrings.count-1, id: \.self) { index in
                    if chosenAvatar == avatarStrings[index] {
                        Button(action: {
                            chosenAvatar = avatarStrings[index]
                        }, label: {
                            ZStack(alignment: .center) {
                                Image(avatarStrings[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: CGFloat(90), height: CGFloat(90))
                                    .clipShape(Circle())
                            }
                        })
                    } else {
                        Button(action: {
                            chosenAvatar = avatarStrings[index]
                        }, label: {
                            ZStack(alignment: .center) {
                                Image(avatarStrings[index])
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.5)
                                    .frame(width: CGFloat(90), height: CGFloat(90))
                                    .clipShape(Circle())
                            }
                        })
                    }
                }
            }
            .padding()
        }
    }
}

struct CreateUserFields_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserFields(userData: .constant(usersData[0].data),
                         password: .constant(""),
                         chosenAvatar: .constant(""))
    }
}
