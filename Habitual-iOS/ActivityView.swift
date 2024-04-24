//
//  ActivityView.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI
import Charts

struct ActivityView: View 
{
    // State var to hold line graph data
    @State public var habit1Reps: [Int] = [1, 10, 2, 7, 7, 8, 9]
    // State current page
    @State private var currentPage: String = "Activity"
    
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // Access the binding directly within the view's body
    var recordsBinding: Binding<Array<Record>>
    {
        Binding(get: { self.records }, set: { self.records = $0 })
    }
    
    var body: some View 
    {
        // Nav section
        NavigationView
        {
            NavigationSection(currentPage: currentPage)
        }
        .frame(width: .infinity, height: 90)
        // define x values to show on chart
        let xValues = [1, 2, 3, 4, 5, 6, 7]
        Chart
        {
            // Create a line chart
            LineMark(
                x: .value("Day", 1),
                y: .value("num", habit1Reps[0])
            )
            LineMark(
                x: .value("Day", 2),
                y: .value("num", habit1Reps[1])
            )
            LineMark(
                x: .value("Day", 3),
                y: .value("num", habit1Reps[2])
            )
            LineMark(
                x: .value("Day", 4),
                y: .value("num", habit1Reps[3])
            )
            LineMark(
                x: .value("Day", 5),
                y: .value("num", habit1Reps[4])
            )
            LineMark(
                x: .value("Day", 6),
                y: .value("num", habit1Reps[5])
            )
            LineMark(
                x: .value("Day", 7),
                y: .value("num", habit1Reps[6])
            )
            
        }
        .frame(height: 300)
        .chartXScale(domain: ClosedRange(uncheckedBounds: (lower: 1.0, upper: 7.0)))
        .chartXAxis {
            AxisMarks(values: xValues)
        }
        
        Spacer()
        // Split habits list into two sub-lists
        let numHabits = habits.count
        let halfHabits = numHabits / 2
        let habitsLeft = Array(habits[0..<halfHabits])
        let habitsRight = Array(habits[halfHabits..<numHabits])
        Spacer()
        // Spacing between VStacks
        ScrollView
        {
            HStack(spacing: 0)
            {
                // Display left column
                VStack
                {
                      ForEach(habitsLeft)
                      { 
                          habit in
                          Button(action:
                          {
                              lineChartUpdate(habit: habit)
                          }) 
                          {
                              Text(habit.name)
                                  .modifier(HabitActivityStyle())
                                  .frame(maxWidth: .infinity)
                          }
                      }
                }
                // Display right column
                VStack
                {
                      ForEach(habitsRight)
                      { 
                          habit in
                          Button(action:
                          {
                              lineChartUpdate(habit: habit)
                          }) 
                          {
                              Text(habit.name)
                                  .modifier(HabitActivityStyle())
                                  .frame(maxWidth: .infinity)
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
        .frame(width: .infinity, height: .infinity)
    }
    
    // ============ LINE CHART UPDATE ============= //
    func lineChartUpdate(habit: Habit) -> Void
    {
        var tmpRecordsList: [Int] = []
        // Iterate through records
            for record in records 
            {
                if habit.habitId == record.habitId
                {
                    // convert to an integer and add it to tmpRecordsList
                    if let updateNumInt = Int(record.updateNum)
                    {
                        // Only list the first 7 data points
                        if(tmpRecordsList.count < 7)
                        {
                            tmpRecordsList.append(updateNumInt)
                        }
                    }
                    else
                    {
                        // Handle failed conversion to Int
                        print("Error: Unable to convert \(record.updateNum) to an integer.")
                    }
                }
            }
        var habit2Reps: [Int] = Array(repeating: 0, count: 7)
        // set tmpRecordsList to habit2Reps []
        for i in 0..<tmpRecordsList.count
        {
            habit2Reps[i] = tmpRecordsList[i]
        }

        print(habit2Reps)
        // update the line graph data
        habit1Reps = habit2Reps
    }


    // ========= FETCH ALL HABITS ========= //
    func fetchHabits() async
    {
        do
        {
            let habitsList = try await getHabits()
            // Update state var for consistent UI updates
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

            // Update the state var array
            DispatchQueue.main.async
            {
                self.records = rawRecordsList
            }
        } 
        catch
        {
            print("Error fetching records: \(error)")
        }
    }
}

#Preview {
    ActivityView()
}
