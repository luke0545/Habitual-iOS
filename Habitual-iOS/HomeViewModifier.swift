//
//  HomeViewModifier.swift
//  Habitual-iOS
//
//  Created by Luke on 1/30/24.
//

import Foundation
import SwiftUI

struct HabitStyle: ViewModifier 
{
    let habitGreen = Color(red: 0.17, green: 0.33, blue: 0.2)
    func body(content: Content) -> some View 
    {
        content
            .frame(width:170, height: 40)
            .padding(15)
            .background(habitGreen.opacity(0.7))
            .cornerRadius(6)
    }
}

struct HabitColor: ViewModifier 
{
    enum ColorScheme: String 
    {
        case good = "good"
        case bad = "bad"
    }

    let colorScheme: ColorScheme

    func body(content: Content) -> some View 
    {
        content
            .foregroundColor(colorScheme == .good ? .green : .red)
    }
}

#Preview {
    HomeView()
}
