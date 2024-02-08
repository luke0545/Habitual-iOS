//
//  ContentView.swift
//  Habitual-iOS
//
//  Created by Luke
//

import SwiftUI

struct HomeView: View {
    @State private var habits: [Habit] = [] // Initially empty
    
    var body: some View {
        VStack {
            
            // Define List of Habit objects
            List(habits)
            {
                habitName in
                Text(habitName.name)
//                    .modifier(HabitStyle())
//                    .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                
            }
            .onAppear {
                getHabits 
                { fetchedHabits, error in
                    if let fetchedHabits = fetchedHabits 
                    {
                        self.habits = fetchedHabits // Assign fetched habits to the state variable
                        print("This does not show in console")
                    } else if let error = error
                    {
                        // Handle the error
                    }
                }
            }
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}


func getHabits(completion: @escaping ([Habit]?, Error?) -> Void)
{
    // Use URLSession or a networking library to make the API call
    // Example using URLSession:
    URLSession.shared.dataTask(with: URL(string: "http://localhost:3000/allhabits")!) { data, response, error in
        if let data = data 
        {
            do 
            {
                let habits = try JSONDecoder().decode([Habit].self, from: data)
                print(habits)
                completion(habits, nil)
            } catch
            {
                completion(nil, error)
            }
        } else if let error = error {
            completion(nil, error)
        }
    }.resume()
}

func getHabitNames(completion: @escaping ([HabitName]?, Error?) -> Void)
{
    // Use URLSession or a networking library to make the API call
    // Example using URLSession:
    URLSession.shared.dataTask(with: URL(string: "localhost:3000/allhabitnames")!) { data, response, error in
        if let data = data
        {
            do
            {
                let habits = try JSONDecoder().decode([HabitName].self, from: data)
                print("asdf")
                completion(habits, nil)
            } catch
            {
                completion(nil, error)
            }
        } else if let error = error {
            completion(nil, error)
        }
    }.resume()
}
#Preview {
    HomeView()
}
