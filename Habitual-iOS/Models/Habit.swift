//
//  Habit.swift
//  Habitual-iOS
//
//  Created by Luke on 1/27/24.
//

import Foundation

struct Habit: Codable, Identifiable {
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
    // Initializer
//    init(id: Int, habit_id: Int, name: String, type: String, difficulty: Int, user_id: Int, repetitions_day: Int, repetitions_week: Int)
//    {
//        self.id = id
//        self.habit_id = habit_id
//        self.name = name
//        self.type = type
//        self.difficulty = difficulty
//        //self.dateAdded = dateAdded
//        self.user_id = user_id
//        self.repetitions_day = repetitions_day
//        self.repetitions_week = repetitions_week
//    }
    
    // Use CodingKeys if you want explicit control over key mapping
    // enum CodingKeys: String, CodingKey {
    //     case habitId = "habit_id"
    //     case name
    //     case type
    //     case difficulty
    //     case dateAdded = "date_added"
    //     case userId = "user_id"
    //     case repetitionsDay = "repetitions_day"
    //     case repetitionsWeek = "repetitions_week"
    // }
//    mutating func generateTodaysDate()
//    {
//        self.date_added = Date()
//        print("ISO format: ",self.date_added.ISO8601Format())
//    }
    
}
