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
        }
        .buttonStyle(.plain)
    }
}

// Add Habit form
struct CustomPopupView: View 
{
    // Habit parameters
    @State private var habitName = ""
    @State private var repetitionsPerWeek = 1
    @State private var difficulty = 3
    @State private var habitType = true // Default to "Good"
    // check whether plus button is active
    @Binding var showPopup: Bool

    var body: some View 
    {
        VStack
        {
            HStack
            {
                Button(action: 
                {
                    showPopup.toggle() // Close the popup
                }) 
                    {
                        Text("Close")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding()
            }
//            Text("Add Habit")
//                .font(.title)
//                .padding()

            // Add your form inputs here (text fields, pickers, etc.)
            NavigationView {
                        Form {
                            Section(header: Text("Habit Details")) 
                            {
                                TextField("Enter a habit", text: $habitName)
                                Stepper("Anticipated reps per week: \(repetitionsPerWeek)", value: $repetitionsPerWeek, in: 1...14)
                                Picker("Difficulty", selection: $difficulty)
                                {
                                    ForEach(1..<6)
                                    {
                                        level in
                                        Text("\(level)")
                                    }
                                }
                                Toggle("Is it a good habit?", isOn: $habitType)
                            }

                            Section 
                            {
                                Button(action: 
                                {
                                    // Print the habit details to console
                                    print("Habit Name: \(habitName)")
                                    print("Repetitions per day: \(repetitionsPerWeek)")
                                    print("Difficulty: \(difficulty)")
                                    print("Habit Type: \(habitType)")
                                    showPopup.toggle()
                                    
                                    // API call to add habit
                                    
                                })
                                {
                                    Text("Add Habit")
                                }
                            }
                        }
                        .navigationBarTitle("Add Habit")
                    }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}

struct HomeView: View 
{
    // State current page
    @State private var currentPage: String = "Home"
    // State for 'Add Habit' popup
    @State private var showPopup = false
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // Access the binding directly within the view's body
        var recordsBinding: Binding<Array<Record>> 
        {
            Binding(get: { self.records }, set: { self.records = $0 })
        }
    // @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    var body: some View 
    {
        // Nav section
        NavigationView 
        {
            ZStack
            {
                NavigationSection(currentPage: currentPage)
            }
        }
        ZStack
        {
            VStack
            {
                // Title the repetition count
                HStack
                {
                    Spacer()
                    
                    Text("Total")
                        .padding(.horizontal, 80)
                    
                }
                
                List(habits)
                {
                    habit in
                    // for each habit in the array, create HStack to populate each row
                    HStack
                    {
                        PlusButton(action:
                                    {
                            Task
                            {
                                try await updateHabitRecord(habit: habit)
                                // Refresh the records
                                await fetchRecords()
                            }
                        }, recordsBinding: recordsBinding)
                        
                        // Habit name block with ViewModifier
                        Text(habit.name)
                            .modifier(HabitStyle())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        // .modifier(HabitColor(colorScheme: .init(rawValue: habit.type) ?? .bad)) // Apply habit color
                        
                        // list repetitions
                        ForEach(records)
                        {
                            record in
                            if(habit.habitId == record.habitId)
                            {
                                // Display the repetition number
                                Spacer()
                                    .frame(width: 30)
                                Text(record.updateNum)
                                    .font(.system(size: 20))
                                
                            }
                        }
                    }
                }
            }
            // Add Habit button
            // Button to trigger the popup
            Button(action:
            {
                showPopup.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding()
            .offset(x: +140, y: -395) // Adjust the position of the button

            // Custom popup view
            if showPopup
            {
                CustomPopupView(showPopup: $showPopup)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
            }
        }
        
        .task
        {
            await fetchHabits()
            await fetchRecords()
        }
        .padding(0)
        .frame(width:420, height: 670)
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
            // Get records from server
            let rawRecordsList = try await getRecords()

                    // Filter and keep only one record per habit_id
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
    
//    func updateHabitAndRefreshUI(habit: Habit) async -> Int 
//    {
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
