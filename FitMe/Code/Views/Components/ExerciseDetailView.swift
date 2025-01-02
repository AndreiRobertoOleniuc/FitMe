import SwiftData
import SwiftUI

struct ExerciseDetailView: View {
    let workout: Workout
    let exercise: Exercise
    @ObservedObject var viewModel: WorkoutViewModel
    
    @State private var isEditing = false
    @State private var editedSets: Int
    @State private var editedReps: Int
    @State private var editedRest: Int
    
    init(workout: Workout, exercise: Exercise, viewModel: WorkoutViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel
        self.workout = workout
        _editedSets = State(initialValue: exercise.sets)
        _editedReps = State(initialValue: exercise.reps)
        _editedRest = State(initialValue: exercise.rest)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ImageView(
                    imageURL: ImageView.getFullImageURL(exercise.image),
                    size: 200,
                    cornerRadius: 12,
                    systemName: ImageView.getSystemImageName(exercise.category)
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
                
                VStack(spacing: 15) {
                    DetailRow(title: "Sets", value: "\(editedSets)")
                    DetailRow(title: "Reps", value: "\(editedReps)")
                    DetailRow(title: "Rest", value: "\(editedRest) sec")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Exercise Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing = true }) {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationView {
                Form {
                    Section(header: Text("Training Parameters")) {
                        Stepper("Sets: \(editedSets)", value: $editedSets, in: 1...10)
                        Stepper("Reps: \(editedReps)", value: $editedReps, in: 1...30)
                        Stepper("Rest: \(editedRest) sec", value: $editedRest, in: 30...180, step: 15)
                    }
                }
                .navigationTitle("Edit Exercise")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        isEditing = false
                    },
                    trailing: Button("Save") {
                        saveChanges()
                        isEditing = false
                    }
                )
            }
        }
    }
    
    private func saveChanges() {
        let updatedExercise = exercise
        updatedExercise.sets = editedSets
        updatedExercise.reps = editedReps
        updatedExercise.rest = editedRest
        viewModel.updateExerciseInWorkout(updatedExercise, to: workout)
    }
}