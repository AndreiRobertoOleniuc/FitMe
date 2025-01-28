import SwiftUI

struct HomeScreen: View {
    @StateObject var statsViewModel = StatsViewModel(dataSource: .shared)
    @StateObject var workoutViewModel = ActiveWorkoutViewModel(dataSource: .shared)
    @Binding var selectedTab: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Date Section
            VStack(alignment: .leading, spacing: 8) {
                Text(currentDate)
                    .font(.title)
                    .fontWeight(.bold)
                if let nextWorkout = workoutViewModel.getNextWorkoutSuggestion() {
                    NextWorkoutView(workout: nextWorkout) {
                        workoutViewModel.startWorkoutSession(nextWorkout)
                        selectedTab = 2
                    }
                }
            }
            
            Text("Past Active Days")
                .font(.headline)
                .padding(.top)
            
            // Legend
            HStack(spacing: 16) {
                HStack {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 20, height: 20)
                    Text("Worked Out")
                        .font(.caption)
                }
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                    Text("Did Not Work Out")
                        .font(.caption)
                }
            }
            
            // Double the width: 14 columns instead of 7
            let columns = Array(repeating: GridItem(.fixed(20), spacing: 4), count: 14)
            LazyVGrid(columns: columns, spacing: 4) {
                // Double the days: 70 instead of 35
                ForEach(0..<70, id: \.self) { offset in
                    // Reversed day offset so the last cell is "today"
                    let day = Calendar.current.date(byAdding: .day, value: -(69 - offset), to: Date())!
                    Rectangle()
                        .fill(
                            statsViewModel.didUserWorkout(on: day)
                            ? Color.green
                            : Color.gray.opacity(0.3)
                        )
                        .frame(width: 20, height: 20)
                }
            }
            
            
            if let mostPerformed = statsViewModel.getMostPerformedExercise() {
                CompactExerciseProgressChart(
                    exerciseName: mostPerformed.exerciseName,
                    category: mostPerformed.category,
                    performCount: mostPerformed.count,
                    progressData: statsViewModel.getWeightProgressForExercise(named: mostPerformed.exerciseName)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onAppear {
            statsViewModel.fetchAllWorkoutSessions()
            workoutViewModel.findAllPossibleWorkouts()
            workoutViewModel.fetchAllWorkoutSessions()
        }
    }
    
    // Computed property to get the current date
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}
