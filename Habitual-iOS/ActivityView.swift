//
//  ActivityView.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI
import Charts

struct LineChartView: View 
{
    // Repetition data (hardcoded integer array to test)
    let habit1Reps: [Int] = [8, 3, 6, 7, 7, 5, 9] // Habit 1

    var body: some View 
    {
        Chart 
        {
            // Create a line chart with multiple lines
            LineMark(
                x: .value("Day", 0),
                y: .value("num", habit1Reps[0])
            )
            LineMark(
                x: .value("Day", 1),
                y: .value("num", habit1Reps[1])
            )
            LineMark(
                x: .value("Day", 2),
                y: .value("num", habit1Reps[2])
            )
            LineMark(
                x: .value("Day", 3),
                y: .value("num", habit1Reps[3])
            )
            LineMark(
                x: .value("Day", 4),
                y: .value("num", habit1Reps[4])
            )
            LineMark(
                x: .value("Day", 5),
                y: .value("num", habit1Reps[5])
            )
            LineMark(
                x: .value("Day", 6),
                y: .value("num", habit1Reps[6])
            )
        }
        
    }
}

// Usage
struct ContentView: View {
    var body: some View {
        NavigationView {
            LineChartView()
                .navigationBarTitle("Habit Repetitions")
        }
        .frame(height: 300)
    }
    
}


// ============ SELECT HABIT TO VIEW CHART ============= //
struct SelHabButton: View
{
    let action: () -> Void
    let recordsBinding: Binding<Array<Record>>
    
    var body: some View
    {
        Button(action: action)
        {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .padding(5)
                .background(Color.gray.cornerRadius(10))
                .modifier(HabitStyle())
        }
        .buttonStyle(.plain)
    }
}



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
        // Nav section
        NavigationView
        {

                NavigationSection(currentPage: currentPage)

            
        }
        LineChartView()
        
        VStack 
        {
            
            // Display habits[]
            List(habits)
            {
                habitName in
                HStack
                {
                    SelHabButton(action:
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
            await fetchRecords()
        }
        .padding(0)
        .frame(width:420, height: 470)
        
        
    }
    
    // Line chart
    


    // ========= FETCH ALL HABITS ========= //
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
    
    // ========= FETCH RECORDS ========= //
    func fetchRecords() async
    {
        do
        {
            // Get records from server
            let rawRecordsList = try await getRecords()

                    // Filter and keep only one record (the most recent) per habit_id
                    let filteredRecords = Dictionary(grouping: rawRecordsList, by: \.habitId)
                         .values
                         .map { $0.max(by: { $0.updateNum < $1.updateNum })! }

                    // Update the state array on the main thread
                    DispatchQueue.main.async
                    {
                        self.records = filteredRecords
                    }
        } catch
        {
            print("Error fetching records: \(error)")
        }
    }
}



#Preview {
    ActivityView()
}
