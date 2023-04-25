//
//  ActivityAnnotationView.swift
//  RecessTestGrounds
//
//  Created by Torri Ray Porter Jr on 2023-04-25.
//

import SwiftUI

struct ActivityAnnotationView: View {
    var activity: Activity
    
    var body: some View {
            VStack {
                Text(activity.sport)
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.red)
                    .cornerRadius(5)
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
            }
        }
}

struct ActivityAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAnnotationView(activity: activitiesData[0])
    }
}
