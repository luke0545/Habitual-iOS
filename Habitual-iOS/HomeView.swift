//
//  ContentView.swift
//  Habitual-iOS
//
//  Created by Luke
//

import SwiftUI

// Add repetition button
struct PlusButton: View 
{
    let action: () -> Void

    var body: some View 
    {
        Button(action: action) 
        {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.gray.cornerRadius(10))
                //.clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct HomeView: View 
{
    
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    var body: some View 
    {
        //NavigationSection()
        VStack
        {
            // Display habits[]
            List(habits)
            {
                habit in
                // for each habit in the array, create HStack to populate each row
                HStack
                {
                    PlusButton
                    {
                        Task
                        {
                            // call API to increase repetition count
                            print("hello")
                            
                        }
                    }
                    // Habit name block with ViewModifier
                    Text(habit.name)
                       .modifier(HabitStyle())
                       .font(.system(size: 22, weight: .bold))
                       .foregroundColor(.white)
                       .offset(x: -0.0) // Shift 56 points to the left
                       // .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                    
                    // list repetitions
                    let repCount = 0
                    ForEach(records)
                    {
                        record in
                        if(habit.habitId == record.habitId)
                        {
                            //repCount += 1
                            Text(record.updateNum)
                        }
                    }
                }
            }
        }
        .task
        {
            await fetchHabits()
            await fetchRecords()
        }
        .padding(0)
        .frame(width:380, height: 500)
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
    
    func fetchRecords() async
    {
        do
        {
            let recordsList = try await getRecords()
            // Update state on the main thread for consistent UI updates
            DispatchQueue.main.async
            {
                self.records = recordsList
            }
        } catch
        {
            print("Error fetching records: \(error)")
        }
    }
}

#Preview {
    HomeView()
}
