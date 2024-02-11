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

// Update habit record
// method returns Int of updated repetition number
func updateHabitRecord(habit: Habit) async throws -> Int
{
    
    let endpoint = "http://localhost:3000/updatehabitrecord"

    guard let url = URL(string: endpoint) else 
    {
        throw HABError.invalidURL
    }
    // create endpoint string as URL object and set method to POST
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Encode the Habit object as JSON
    let encoder = JSONEncoder()
    // Convert to snake case
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let encodedHabit = try encoder.encode(habit)
    // print what the API is receiving
    print("Habit sending to server: \n\n\n", String(data: encodedHabit, encoding: .utf8)!)
    request.httpBody = encodedHabit

    let (data, response) = try await URLSession.shared.data(for: request)
    print("Response from server: \n\n\n", String(data: data, encoding: .utf8)!)
    // Handle response error
    guard let response = response as? HTTPURLResponse, response.statusCode == 201
    else
    {
        throw HABError.invalidResponse
    }
    // Parse the returned integer value from the response data
    let returnValue = try JSONDecoder().decode(Int.self, from: data)
    return returnValue
}


// Error Handling
enum HABError: Error
{
    case invalidURL
    case invalidResponse
    case invalidData
}
