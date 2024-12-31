import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var showingSearch = false
    @State private var isEditing = false
    @State private var selectedExercise: Exercise?
    
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
                        },
                        onEdit: {
                            selectedExercise = exercise
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
        .sheet(item: $selectedExercise) { exercise in
            EditExerciseSheet(
                exercise: exercise
            ) { updatedExercise in
                if let index = workout.exercises.firstIndex(where: { $0.id == updatedExercise.id }) {
                    workout.exercises[index] = updatedExercise
                }
                viewModel.addExerciseToWorkout(updatedExercise, to: workout)
            }
        }
    }
}
