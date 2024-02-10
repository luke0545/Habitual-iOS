//
//  ContentView.swift
//  Habitual-iOS
//
//  Created by Luke
//

import SwiftUI

struct HomeView: View {
    
    // Initialize empty array
    @State private var habits: [Habit] = []
//    @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    var body: some View {
        VStack {
            
            // Define List of Habit objects
            List(habits)
            {
                habitName in
                Text(habitName.name)
                   .modifier(HabitStyle())
                   .offset(x: -10.0) // Shift 56 points to the left
                   // .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                
            }
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task
        {
            await fetchHabits()
        }
        .padding(0)
        
        
    }
    func fetchHabits() async
    {
        do
        {
            let habitsList = try await getHabits()
            // Update state on the main thread for consistent UI updates
            DispatchQueue.main.async
            {
                self.habits = habitsList
            }
        } catch
        {
            print("Error fetching habits: \(error)")
        }
    }
}


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

#Preview {
    HomeView()
}

enum HABError: Error
{
    case invalidURL
    case invalidResponse
    case invalidData
}
