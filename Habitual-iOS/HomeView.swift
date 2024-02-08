//
//  ContentView.swift
//  Habitual-iOS
//
//  Created by Luke
//

import SwiftUI

struct HomeView: View {
    
    @State private var habits: [Habit] = [] // Initially empty
    @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, dateAdded: Date(), userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    var body: some View {
        VStack {
            
            // Define List of Habit objects
//            List(habits)
//            {
//                habitName in
//                Text(habitName.name)
////                    .modifier(HabitStyle())
////                    .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
//                
//            }
//            .onAppear {
//                getHabits 
//                { fetchedHabits, error in
//                    if let fetchedHabits = fetchedHabits 
//                    {
//                        self.habits = fetchedHabits // Assign fetched habits to the state variable
//                        print("This does not show in console")
//                    } else if let error = error
//                    {
//                        // Handle the error
//                    }
//                }
//            }
//            ForEach(habits)
//            {
//                habit in
//                Text(habit.name)
//                    .modifier(HabitStyle())
//            }
            Text(singleHabit.name)
                .modifier(HabitStyle())
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task
        {
            do
            {
                let habitsList = try await getHabits()
                self.habits = habitsList
            } catch
            {
                print("Error fetching habits: \(error)")
            }
        }
//        .task
//        {
//            do
//            {
//                let habitIndex = habits.count
//                if(habits.count == 0)
//                {
//                    habits[0] = try await getHabits()
//                }
//                else
//                {
//                    habits[habitIndex + 1] = try await getHabits()
//                }
//                
//                
//            } catch HABError.invalidURL
//            {
//                print("invalid URL")
//            } catch HABError.invalidResponse
//            {
//                print("invalid response")
//            } catch HABError.invalidData
//            {
//                print("invalid data")
//            } catch
//            {
//                print("unexpected error")
//            }
//        }
    }
}


func getHabits() async throws -> Habit
{
    let endpoint = "http://localhost:3000/allhabits"
    
    guard let url = URL(string: endpoint) else
    {
        throw HABError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Handle response error
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else
    {
        throw HABError.invalidResponse
    }
    
    // handle data from API
    do
    {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Habit.self, from: data)
    } catch
    {
        throw HABError.invalidData
    }
}

//func getHabits(completion: @escaping ([Habit]?, Error?) -> Void)
//{
//    // Use URLSession or a networking library to make the API call
//    // Example using URLSession:
//    URLSession.shared.dataTask(with: URL(string: "http://localhost:3000/allhabits")!) { data, response, error in
//        if let data = data 
//        {
//            do 
//            {
//                let habits = try JSONDecoder().decode([Habit].self, from: data)
//                print(habits)
//                completion(habits, nil)
//            } catch
//            {
//                completion(nil, error)
//            }
//        } else if let error = error {
//            completion(nil, error)
//        }
//    }.resume()
//}

//func getHabitNames(completion: @escaping ([HabitName]?, Error?) -> Void)
//{
//    // Use URLSession or a networking library to make the API call
//    // Example using URLSession:
//    URLSession.shared.dataTask(with: URL(string: "localhost:3000/allhabitnames")!) { data, response, error in
//        if let data = data
//        {
//            do
//            {
//                let habits = try JSONDecoder().decode([HabitName].self, from: data)
//                print("asdf")
//                completion(habits, nil)
//            } catch
//            {
//                completion(nil, error)
//            }
//        } else if let error = error {
//            completion(nil, error)
//        }
//    }.resume()
//}
#Preview {
    HomeView()
}

enum HABError: Error
{
    case invalidURL
    case invalidResponse
    case invalidData
}
