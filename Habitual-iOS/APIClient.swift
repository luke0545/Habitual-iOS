//
//  APIClient.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation

// GET ALL HABITS //
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


// GET ALL RECORDS //
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

// ADD 1 TO HABIT RECORD //
// method prints Int of updated repetition number
func updateHabitRecord(habit: Habit) async throws -> ()
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
    print(returnValue)
}

// ADD HABIT //
func addHabit(habit: Habit, completion: @escaping (Result<Void, Error>) -> Void) 
{
    // Generate current date time in ISO 8601 format
    let currentDateTimeISO = ISO8601DateFormatter().string(from: Date())

    guard let url = URL(string: "http://localhost:3000/addhabit") else 
    {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Construct JSON body with currentDateTimeISO
    let body: [String: Any] = [
        "name": habit.name,
        "type": habit.type,
        "Difficulty": habit.difficulty,
        "Date_added": "0000-00-00 00:00:00",
        "user_id": habit.userId,
        "repetitions_day": habit.repetitionsDay,
        "repetitions_week": habit.repetitionsWeek
    ]

    do 
    {
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
    } 
    catch 
    {
        completion(.failure(error))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) 
        else
        {
            completion(.failure(HABError.unexpectedResponse))
            return
        }

        completion(.success(()))
    }.resume()
}

func deleteHabit(habit: Habit, completion: @escaping (Error?) -> Void) 
{
    guard let url = URL(string: "http://localhost:3000/removehabit") else
    {
        completion(NSError(domain: "InvalidAPIURL", code: -1, userInfo: nil))
        return
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase // Encode keys in snake_case
        let jsonData = try encoder.encode(habit)
        urlRequest.httpBody = jsonData
      } catch {
        completion(error)
        return
      }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let error = error {
            completion(error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(NSError(domain: "APIError", code: -2, userInfo: nil))
            return
        }
        
        completion(nil)
    }
    
    task.resume()
}


// Error Handling
enum HABError: Error
{
    case invalidURL
    case invalidResponse
    case invalidData
    case unexpectedResponse
}
