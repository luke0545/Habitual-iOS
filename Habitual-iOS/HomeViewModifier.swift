//
//  HomeViewModifier.swift
//  Habitual-iOS
//
//  Created by Luke on 1/30/24.
//

import Foundation
import SwiftUI

struct HabitStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.green.opacity(0.8))
            .cornerRadius(10)
    }
}

struct HabitColor: ViewModifier {
    enum ColorScheme: String {
            case good = "good"
            case bad = "bad"
        }

    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .good ? .green : .red)
    }
}

#Preview {
    HomeView()
}
