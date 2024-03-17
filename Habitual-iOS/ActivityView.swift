//
//  ActivityView.swift
//  Habitual-iOS
//
//  Created by Luke on 2/9/24.
//

import Foundation
import SwiftUI
import Charts

//struct LineChartView: View {
//    // Repetition data (hardcoded integer arrays)
//    let habit1Repetitions: [Int] = [10, 12, 15, 18, 20, 22, 25] // Habit 1
//    let habit2Repetitions: [Int] = [8, 9, 11, 14, 16, 19, 21] // Habit 2
//    // Add more habits as needed...
//
//    var body: some View {
//        Chart {
//            // Create a line chart with multiple lines
//            LineMark(x: .value("Day", 1), y: .value(habit1Repetitions[0]))
//            LineMark(x: .array(Array(0..<7).map(Int.init)), y: .array(habit2Repetitions))
//            // Add more lines for additional habits...
//        }
//    }
//}
//
//// Usage
//struct ContentView: View {
//    var body: some View {
//        NavigationView {
//            LineChartView()
//                .navigationBarTitle("Habit Repetitions")
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



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

        //LineChartView()
        
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
    
    // Line chart
    


    
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
