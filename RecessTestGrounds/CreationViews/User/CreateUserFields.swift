//
//  CreateUserFields.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-05-02.
//

import SwiftUI

struct CreateUserFields: View {
    @EnvironmentObject var tD: TestData
    @Binding var userData: User.Data
    @Binding var password: String
    @Binding var confirmedPassword: String
    @Binding var chosenAvatar: String
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            SuperTextField(placeholder: Text("   Name").foregroundColor(.white),
                           text: $userData.name)
            .modifier(FormField())
            if !tD.loggedIn {
                SuperTextField(placeholder: Text("   Email").foregroundColor(.white),
                               text: $userData.email)
                .modifier(FormField())
                SuperTextField(placeholder: Text("   Password").foregroundColor(.white),
                               text: $password)
                .modifier(FormField())
                SuperTextField(placeholder: Text("   Confirm Password").foregroundColor(.white),
                               text: $confirmedPassword)
                .modifier(FormField())
            }
            Text("Choose an Avatar")
                .modifier(SectionHeader())
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0...avatarStrings.count-1, id: \.self) { index in
                    if chosenAvatar == avatarStrings[index] {
                        ChosenAvatarView(chosenAvatar: $chosenAvatar,
                                         index: index,
                                         avatarStrings: avatarStrings)
                    } else {
                        BlurredAvatarView(chosenAvatar: $chosenAvatar,
                                          index: index,
                                          avatarStrings: avatarStrings)
                    }
                }
            }
            .padding()
        }
    }
}

struct ChosenAvatarView: View {
    @Binding var chosenAvatar: String
    var index: Int
    var avatarStrings: [String]
    
    var body: some View {
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
    }
}

struct BlurredAvatarView: View {
    @Binding var chosenAvatar: String
    var index: Int
    var avatarStrings: [String]
    
    var body: some View {
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

struct CreateUserFields_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserFields(userData: .constant(usersData[0].data),
                         password: .constant(""),
                         confirmedPassword: .constant(""),
                         chosenAvatar: .constant(""))
    }
}
