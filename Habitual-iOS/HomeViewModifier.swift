//
//  HomeViewModifier.swift
//  Habitual-iOS
//
//  Created by Luke on 1/30/24.
//

import Foundation
import SwiftUI

struct HabitStyle: ViewModifier {
    let skyBlue = Color(red: 0.27, green: 0.7392, blue: 0.5)
    func body(content: Content) -> some View {
        content
            .frame(width:200, height: 50)
            .padding(12)
            .background(skyBlue.opacity(0.7))
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
