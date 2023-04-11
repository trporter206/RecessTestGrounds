//
//  Modifiers.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-03.
//

import Foundation
import SwiftUI

struct TierText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.light)
            .foregroundColor(Color("TextBlue"))
    }
}

struct PageTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.system(size: 36))
    }
}

struct TierTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("TextBlue"))
            .bold()
    }
}

struct SectionHeader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .bold()
            .foregroundColor(Color("TextBlue"))
            .padding()
    }
}

struct FormField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("TextBlue"))
                .frame(height: 30))
            .padding()
    }
}
