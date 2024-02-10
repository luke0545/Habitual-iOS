//
//  APIClient.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation

// Get all habits
func getHabits() async throws -> [Habit]
{
    let endpoint = "http://localhost:3000/allhabits"
    
    guard let url = URL(string: endpoint) else
    {
        throw HABError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    //print("Received Data: ", data)
    
    // Handle response error
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else
    {
        throw HABError.invalidResponse
    }
    
    // handle data from API
    do
    {
        let decoder = JSONDecoder()
        // convert property names from snake_case in the database to camelCase to comply with swift best practices
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //print("Raw JSON data:", String(decoding: data, as: UTF8.self))
        return try decoder.decode([Habit].self, from: data)
    } catch
    {
        throw HABError.invalidData
    }
}


// Get all records
func getRecords() async throws -> [Record]
{
    let endpoint = "http://localhost:3000/allrecords"
    
    guard let url = URL(string: endpoint) else
    {
        throw HABError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    //print("Received Data: ", data)
    
    // Handle response error
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else
    {
        throw HABError.invalidResponse
    }
    
    // handle data from API
    do
    {
        let decoder = JSONDecoder()
        // convert property names from snake_case in the database to camelCase to comply with swift best practices
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        //print("Raw JSON data:", String(decoding: data, as: UTF8.self))
        return try decoder.decode([Record].self, from: data)
    } catch
    {
        throw HABError.invalidData
    }
}

// Error Handling
enum HABError: Error
{
    case invalidURL
    case invalidResponse
    case invalidData
}
