//
//  Record.swift
//  Habitual-iOS
//
//  Created by Luke on 2/10/24.
//

import Foundation

struct Record: Codable, Identifiable
{
    var recordId: Int
    var updateTime: String
    var updateNum: String
    var habitId: Int
    
    var id: Int { recordId }
}
