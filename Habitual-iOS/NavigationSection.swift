//
//  NavigationSection.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct NavigationSection: View {
    let currentPage: String // "Home" or "Activity"

    var body: some View {
        VStack
        {
            Text("Habitual")
                .font(.title)
                .fontWeight(.bold)
                .padding(10)

            HStack {
                
                Spacer()
                Text("Home")
                    .font(.body)
                    .foregroundColor(currentPage == "Home" ? Color.accentColor : .gray)
                    .padding(.horizontal, 40)
                    .fontWeight(.bold)
                
                Text("Activity")
                    .font(.body)
                    .foregroundColor(currentPage == "Activity" ? Color.accentColor : .gray)
                    .padding(.horizontal, 40)
                    .fontWeight(.bold)
                Spacer()
            }
        }
    }
}

#Preview {
    ParentHomeView()
}
