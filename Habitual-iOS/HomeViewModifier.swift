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
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.white)
    }
}

struct HabitActivityStyle: ViewModifier
{
    let habitGreen = Color(red: 0.17, green: 0.33, blue: 0.2)
    func body(content: Content) -> some View
    {
        content
            .frame(width:150, height: 40)
            .padding(15)
            .background(habitGreen.opacity(0.7))
            .cornerRadius(6)
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(.white)
    }
}

struct HabitDetailsStyle: ViewModifier
{
    let habitGreen = Color(red: 0.17, green: 0.33, blue: 0.2)
    func body(content: Content) -> some View
    {
        content
            .frame(width:270, height: 20)
            .padding(15)
            .background(habitGreen.opacity(0.7))
            .cornerRadius(6)
            .foregroundColor(.white)
            .font(.system(size: 22, weight: .bold))
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

struct HabitDeleteStyle: ViewModifier
{
    let deleteRed = Color(red: 0.47, green: 0.13, blue: 0.2)
    func body(content: Content) -> some View
    {
        content
            .frame(width:70, height: 15)
            .padding(15)
            .background(deleteRed.opacity(0.7))
            .cornerRadius(6)
            .foregroundColor(.white)
            .font(.system(size: 22, weight: .bold))
    }
}

#Preview {
    HomeView()
}
