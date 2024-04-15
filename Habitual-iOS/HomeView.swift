//
//  ContentView.swift
//  Habitual-iOS
//
//  Created by Luke
//

import SwiftUI

// ============ ADD HABIT REP (+) BUTTON ============= //
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

// ============ ADD HABIT FORM ============= //
struct AddHabitPopupView: View
{
    // Habit parameters
    @State private var habitName = ""
    @State private var repetitionsPerWeek = 1
    @State private var difficulty = 3
    @State private var habitType = true // Default to "Good"
    @State private var habitGood = ""
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

            // Add habit form input fields
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
                                    
                                    let sendHabit = Habit(habitId: 2, name: habitName, type: habitType ? "good" : "bad", difficulty: difficulty, userId: 1, repetitionsDay: 0, repetitionsWeek: repetitionsPerWeek)
                                    
                                    addHabit(habit: sendHabit)
                                    { 
                                        result in
                                        switch result {
                                        case .success:
                                            print("Habit added")
                                        case .failure(let error):
                                            print("Error adding habit: \(error)")
                                        }
                                    }
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

struct ParentHomeView: View {

  var body: some View {
      VStack
      {
          NavigationView
          {

              NavigationSection(currentPage: "Home")

          }
          HomeView()
      }
      
//    TabView {
//      // Home view
//      HomeView()
//        .tabItem {
//          Label("Home", systemImage: "house")
//        }
//
//      // Activity view (replace with your ActivityView)
//      ActivityView()
//        .tabItem {
//          Label("Activity", systemImage: "bell")
//        }
//    }
  }
}

struct HomeView: View 
{
    // State current page
    @State public var currentPage: String = "Home"
    // State for 'Add Habit' popup
    @State private var showAddHabitPopup = false
    // State for Details popup
    @State private var showDetails = false
    // Store the selected Habit
    @State private var selectedHabit: Habit?
    // Store the selected Habit Record count
    
    // Initialize empty arrays
    @State private var habits: [Habit] = []
    @State private var records: [Record] = []
    
    // Access the binding directly within the view's body
        var recordsBinding: Binding<Array<Record>> 
        {
            Binding(get: { self.records }, set: { self.records = $0 })
        }
    // @State private var singleHabit: Habit = Habit(id: 1, habitId: 2, name: "Workout", type: "Good", difficulty: 4, userId: 3, repetitionsDay: 1, repetitionsWeek: 4)
    
    // ============ HABIT LIST VIEW ============= //
    var body: some View
    {
        // Nav section
        
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
                { habit in
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
                        
                        // HABIT NAME BUTTON CLICK
                        Button(habit.name)
                        {
                            selectedHabit = habit
                            showDetails = true
                        }
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
                .popover(isPresented: $showDetails) 
                        {
                            if let selectedHabit = selectedHabit
                            {
                                showHabitDetails(habit: selectedHabit)
                            }
                        }
            }
            .task
            {
                await fetchHabits()
                await fetchRecords()
            }
            .padding(0)
            .frame(width:420, height: 670)
            
            // Add Habit button
            // Button to trigger the popup
            Button(action:
            {
                showAddHabitPopup.toggle()
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding()
            .offset(x: +140, y: -395) // Adjust the position of the button
            .popover(isPresented: $showAddHabitPopup)
                    {
                        AddHabitPopupView(showPopup: $showAddHabitPopup)

                    }
        }
        
        
    }
    
    func getTotalReps(habit: Habit) -> String
    {
        var totalReps = 0
        for record in records
        {
            if(habit.habitId == record.habitId)
            {
                return record.updateNum
                
            }
        }
        
        return "0"
    }
    func getHabitById(id: Int) -> Habit
    {
        var returnHab = Habit(habitId: 2, name: "habitName", type: "good", difficulty: 3, userId: 1, repetitionsDay: 0, repetitionsWeek: 3)
        for habit in habits
        {
            if(habit.habitId == id)
            {
                returnHab = habit
                
            }
        }
        return returnHab
    }
    
    func calculateAvgReps(habit: Habit) -> Double
    {
        var repGoal = 0
        var isDayGoal = true
        // Is a string value at first
        let totalReps = Double(getTotalReps(habit: habit))
        
        if(habit.repetitionsDay == 0)
        {
            repGoal = habit.repetitionsWeek
            isDayGoal = false
        }
        if(habit.repetitionsWeek == 0)
        {
            repGoal = habit.repetitionsDay
        }
        //print("\(totalReps)")
        
        if let unwrappedTotalReps = totalReps
        {
            return unwrappedTotalReps / Double(repGoal)
        } 
        else
        {
            return totalReps!
        }
    }
    
    // ============ SHOW HABIT DETAILS ============= //
    func showHabitDetails(habit: Habit) -> some View
    {
        return VStack
        {
            // Details header
            VStack
            {
                Text("Details")
                    .font(.system(size: 35, weight: .bold))
                //Spacer()
            }
            // Display Habit name
            VStack
            {
                Text("\(habit.name)")
                .modifier(HabitDetailsStyle())
                
            }
            // STAT TITLES
            HStack
            {
                HStack
                {
                    // Justify Left
                    VStack(alignment: .leading)
                    {
                        Text("Date Added:")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("Rep Goal:")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("Avg Reps:")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("Total Reps:")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("Difficulty:")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        
                        Spacer()
                    }
                    //Spacer()
                }
                // STAT VALUES
                HStack
                {
                    // Justify Right
                    VStack(alignment: .leading)
                    {
                        let currentDate = Date()
                        let formattedDate = currentDate.formatted(date: .abbreviated, time: .omitted)
                        Text("\(formattedDate)")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("\(habit.repetitionsDay) per day")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        // limit to 2 decimal places
                        Text("\(String(format: "%.2f", calculateAvgReps(habit: habit))) per day")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("\(getTotalReps(habit: habit))")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        Text("\(habit.difficulty)")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical, 10)
                        
                        Spacer()
                    }
                }
            }
            
            // Delete Button
            HStack
            {
                Spacer()
                Button(action:
                {
                    deleteHabit(habit: habit)
                    {
                        error in
                        if let error = error 
                        {
                            print("Error removing habit: \(error)")
                        }
                        else
                        {
                            print("Habit successfully removed!")
                        }
                    }
                    print("Deleted")
                })
                {
                    
                    Text("Delete")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                .modifier(HabitDeleteStyle())
                .offset(x: -30, y: +0)
                
            }
        }
        .padding(0)
        .frame(width:420, height: 670)
        .background(Color.white)
        .cornerRadius(10)
        
    }
    
    
    // ========= FETCH HABITS ========= //
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
    ParentHomeView()
}
