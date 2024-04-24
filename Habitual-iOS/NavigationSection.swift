//
//  NavigationSection.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI

import SwiftUI

// Top 10% of each page with the "Habitual" title, along with the two "Home" and "Activity" pages. Current page is highlighted in blue
struct NavigationSection: View {
    let currentPage: String

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
                    // highlight in blue if page is selected
                    .foregroundColor(currentPage == "Home" ? Color.accentColor : .gray)
                    .padding(.horizontal, 40)
                    .fontWeight(.bold)
                
                Text("Activity")
                    .font(.body)
                    // highlight in blue if page is selected
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
