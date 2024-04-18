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
    let habit1Reps: [Int] = [1, 3, 6, 7, 7, 8, 9] // Habit 1

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
            //.stroke(.green, lineWidth: 2)
            // Customize chart labels
            
        }
        //.chartXScale(domain: ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"])
    }
}

// Usage
struct ContentView: View {
    var body: some View {
        NavigationView {
            LineChartView()
                .navigationBarTitle("Habit Repetitions")
        }
        .frame(height: 400)
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
    
    
    var body: some View 
    {
        // Nav section
        NavigationView
        {
            NavigationSection(currentPage: currentPage)
        }
        
        LineChartView()
            .frame(height: 340)
        // Split habits list into two sub-lists
        let numHabits = habits.count
        var halfHabits = numHabits / 2
        let habitsLeft = Array(habits[0..<halfHabits])
        let habitsRight = Array(habits[halfHabits..<numHabits])

        // Spacing between VStacks
        HStack(spacing: 0)
        {

            VStack 
            {
                  ForEach(habitsLeft)
                  { habit in
                        Text(habit.name)
                        .modifier(HabitActivityStyle())
                        .frame(maxWidth: .infinity)
                  }
            }

            VStack 
            {
                  ForEach(habitsRight)
                  { habit in
                        Text(habit.name)
                          .modifier(HabitActivityStyle())
                          .frame(maxWidth: .infinity)
                  }
            }
        }
        .task
        {
            await fetchHabits()
            await fetchRecords()
        }
        .padding(0)
        .frame(width: .infinity, height: .infinity)
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
