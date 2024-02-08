//
//  HabitName.swift
//  Habitual-iOS
//
//  Created by Luke on 1/30/24.
//

import Foundation

struct HabitName: Identifiable, Decodable
{
    var id: Int
    var name: String
    
    init(id: Int, name: String)
    {
        self.id = id
        self.name = name
    }
}
