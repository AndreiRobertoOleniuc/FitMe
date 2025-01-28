import SwiftData
import SwiftUI

struct ExerciseDetailView: View {
    let workout: Workout
    let exercise: Exercise
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State private var isEditing = false
    
    ///Picker Related Internal State
    @State private var editedSets: Int
    @State private var editedReps: Int
    @State private var editedRest: Int
    @State private var editedWeight: Double
    
    init(workout: Workout, exercise: Exercise, viewModel: WorkoutViewModel) {
        self.workout = workout
        self.exercise = exercise
        self.viewModel = viewModel
        _editedSets = State(initialValue: exercise.sets)
        _editedReps = State(initialValue: exercise.reps)
        _editedRest = State(initialValue: exercise.rest)
        _editedWeight = State(initialValue: exercise.weight)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ImageView(
                    imageURL: ImageView.getFullImageURL(exercise.image),
                    cornerRadius: 12,
                    systemName: exercise.systemImage
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(exercise.name)
                        .font(.title2)
                        .bold()
                    Text(exercise.category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                ExerciseParametersView(
                    sets: editedSets,
                    reps: editedReps,
                    rest: editedRest,
                    weight: editedWeight
                )
                .padding(.horizontal)
            }
        }
        .navigationTitle("Exercise Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") { isEditing = true }
            }
        }
        .sheet(isPresented: $isEditing) {
            ExerciseEditSheet(
                isPresented: $isEditing,
                sets: $editedSets,
                reps: $editedReps,
                rest: $editedRest,
                weight: $editedWeight,
                onSave: saveChanges
            )
        }
    }
    
    private func saveChanges() {
        let updatedExercise = exercise
        updatedExercise.sets = editedSets
        updatedExercise.reps = editedReps
        updatedExercise.rest = editedRest
        updatedExercise.weight = editedWeight
        viewModel.updateExerciseInWorkout(updatedExercise, to: workout)
    }
}



