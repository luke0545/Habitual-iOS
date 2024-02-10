//
//  NavigationSection.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI

struct NavigationSection: View {
    @State private var currentPage: String = "Home"

    var body: some View {
        VStack {
            HStack {
                Button(currentPage == "Home" ? "Home (active)" : "Home") {
                    currentPage = "Home"
                }
                .buttonStyle(.plain)
                .foregroundColor(currentPage == "Home" ? .blue : .gray)

                Button(currentPage == "Activity" ? "Activity (active)" : "Activity") {
                    currentPage = "Activity"
                }
                .buttonStyle(.plain)
                .foregroundColor(currentPage == "Activity" ? .blue : .gray)
            }
            .padding(.horizontal)

            // Place your content views for Home and Activity here
            if currentPage == "Home" {
                HomeView()
            } else {
                ActivityView()
            }
        }
    }
}
