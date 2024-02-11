//
//  ActivityView.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI

struct ActivityView: View 
{
    // State current page
    @State private var currentPage: String = "Activity"
    
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // Access the binding directly within the view's body
        var recordsBinding: Binding<Array<Record>> {
            Binding(get: { self.records }, set: { self.records = $0 })
        }
//    @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    
    var body: some View {
        
        
        
        VStack {
            
            // Display habits[]
            List(habits)
            {
                habitName in
                HStack
                {
                    PlusButton(action: 
                    {
                        Task
                        {
                            print("hello")
                        }
                    }, recordsBinding: recordsBinding)
                    
                    Text(habitName.name)
                       .modifier(HabitStyle())
                       .offset(x: -0.0) // Shift 56 points to the left
                       // .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                }
                
            }
            
        }
        .task
        {
            await fetchHabits()
        }
        .padding(0)
        //.frame(width:280, height: 500)
        
        
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

#Preview {
    ActivityView()
}
