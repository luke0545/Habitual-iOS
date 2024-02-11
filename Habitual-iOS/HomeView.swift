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
                //.clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct HomeView: View 
{
    // State current page
    @State private var currentPage: String = "Home"
    
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // Access the binding directly within the view's body
        var recordsBinding: Binding<Array<Record>> {
            Binding(get: { self.records }, set: { self.records = $0 })
        }
    // @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    var body: some View 
    {
        
        NavigationView {
            ZStack {
                NavigationSection(currentPage: currentPage)
                    
            }
        }
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
                    //let repCount = 0
                    PlusButton(action: {
                        Task {
                            try await updateHabitRecord(habit: habit)
                            await fetchRecords() // Refresh the records
                        }
                    }, recordsBinding: recordsBinding)
                    
                    // Habit name block with ViewModifier
                    Text(habit.name)
                       .modifier(HabitStyle())
                       .font(.system(size: 22, weight: .bold))
                       .foregroundColor(.white)
                       .offset(x: -0.0) // Shift 56 points to the left
                       // .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                    
                    // list repetitions
                    ForEach(records)
                    {
                        record in
                        if(habit.habitId == record.habitId)
                        {
                            // Use a binding to update the view
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
            let rawRecordsList = try await getRecords() // Get records from server

                    // Filter and keep only one record per habit_id
                    let filteredRecords = Dictionary(grouping: rawRecordsList, by: \.habitId)
                         .values
                         .map { $0.max(by: { $0.updateNum < $1.updateNum })! }

                    // Update the state array on the main thread
                    DispatchQueue.main.async {
                        self.records = filteredRecords
                    }
        } catch
        {
            print("Error fetching records: \(error)")
        }
    }
    
//    func updateHabitAndRefreshUI(habit: Habit) async -> Int {
//
//            do {
//                let returnInt = try await updateHabitRecord(habit: habit)
//                print("Habit record updated successfully!")
//                await fetchRecords() // Refresh the records
//                return returnInt
//            } catch {
//                print("Error updating habit record: \(error)")
//                // Handle errors appropriately
//            }
//        return 0
//    }
}

#Preview {
    HomeView()
}
