//
//  Habit.swift
//  Habitual-iOS
//
//  Created by Luke on 1/27/24.
//

import Foundation

struct Habit: Identifiable, Decodable
{
    // Member variables
    var id: UUID
    var name: String
    var type: String
    var difficulty: Int
    var date_added: Date
    var user_id: Int
    var repetitions_day: Int
    var repetitions_week: Int
    
    // Initializer
    init(id: UUID, name: String, type: String, difficulty: Int, date_added: Date, user_id: Int, repetitions_day: Int, repetitions_week: Int) {
        self.id = id
        self.name = name
        self.type = type
        self.difficulty = difficulty
        self.date_added = date_added
        self.user_id = user_id
        self.repetitions_day = repetitions_day
        self.repetitions_week = repetitions_week
    }
    
    enum CodingKeys: String, CodingKey
    {
        case id = "habit_id" // Assume "habit_id" in the database
        case name
        case type
        case date_added = "date-added" // Assume "date_added" in the database
    }
//    mutating func generateTodaysDate()
//    {
//        self.date_added = Date()
//        print("ISO format: ",self.date_added.ISO8601Format())
//    }
    
}
