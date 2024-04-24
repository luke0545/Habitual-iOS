//
//  Habit.swift
//  Habitual-iOS
//
//  Created by Luke on 1/27/24.
//

import Foundation

struct Habit: Codable, Identifiable 
{
    var habitId: Int // Assuming this is unique for each habit
    var name: String
    var type: String
    var difficulty: Int
    var dateAdded: Date? // Optional to handle potential null values
    var userId: Int
    var repetitionsDay: Int
    var repetitionsWeek: Int

    // Conform to Identifiable
    var id: Int { habitId }

}
