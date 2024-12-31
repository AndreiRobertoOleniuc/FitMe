import SwiftUI

struct WorkoutDetailView: View {
    let workout: WorkoutDataModel
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var showingSearch = false
    @State private var isEditing = false
    
    var body: some View {
        List {
            WorkoutDetailsSection(workout: workout)
            
            Section(header: Text("Exercises")) {
                ForEach(workout.exercises) { exercise in
                    WorkoutExerciseRow(
                        exercise: exercise,
                        isEditing: isEditing,
                        onDelete: {
                            viewModel.deleteExerciseFromWorkout(exercise, to: workout)
                        }
                    )
                }
            }
        }
        .navigationTitle("Workout Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSearch = true }) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchExercise(viewModel: viewModel, workout: workout)
        }
    }
}
