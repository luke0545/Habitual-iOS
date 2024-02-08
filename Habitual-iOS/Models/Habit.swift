//
//  Habit.swift
//  Habitual-iOS
//
//  Created by Luke on 1/27/24.
//

import Foundation

struct Habit: Codable, Identifiable
{
    // Member variables
    var id: Int
    var habitId: Int
    var name: String
    var type: String
    var difficulty: Int
    var dateAdded: Date
    var userId: Int
    var repetitionsDay: Int
    var repetitionsWeek: Int
    
    // Initializer
    init(id: Int, habitId: Int, name: String, type: String, difficulty: Int, dateAdded: Date, userId: Int, repetitionsDay: Int, repetitionsWeek: Int)
    {
        self.id = id
        self.habitId = habitId
        self.name = name
        self.type = type
        self.difficulty = difficulty
        self.dateAdded = dateAdded
        self.userId = userId
        self.repetitionsDay = repetitionsDay
        self.repetitionsWeek = repetitionsWeek
    }
    
//    enum CodingKeys: String, CodingKey
//    {
//        case id = "habit_id" // Assume "habit_id" in the database
//        case name
//        case type
//        case date_added = "date-added" // Assume "date_added" in the database
//    }
//    mutating func generateTodaysDate()
//    {
//        self.date_added = Date()
//        print("ISO format: ",self.date_added.ISO8601Format())
//    }
    
}
