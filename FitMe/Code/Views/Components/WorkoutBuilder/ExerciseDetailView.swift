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
                    width: .infinity,
                    height: .infinity,
                    cornerRadius: 12,
                    systemName: ImageView.getSystemImageName(exercise.category)
                )
                
                exerciseHeader
                
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
    
    private var exerciseHeader: some View {
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

struct ExerciseParametersView: View {
    let sets: Int
    let reps: Int
    let rest: Int
    let weight: Double
    
    var body: some View {
        VStack(spacing: 15) {
            DetailRow(title: "Sets", value: "\(sets)")
            DetailRow(title: "Reps", value: "\(reps)")
            DetailRow(title: "Rest", value: "\(rest) sec")
            DetailRow(title: "Weight", value: "\(weight) kg")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}


struct ExerciseEditSheet: View {
    @Binding var isPresented: Bool
    @Binding var sets: Int
    @Binding var reps: Int
    @Binding var rest: Int
    @Binding var weight: Double
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Training Parameters")) {
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...30)
                    Stepper("Rest: \(rest) sec", value: $rest, in: 30...180, step: 15)
                    Stepper("Weight: \(weight, specifier: "%.1f") kg", 
                           value: $weight, 
                           in: 2.5...300, 
                           step: 2.5)
                }
            }
            .navigationTitle("Edit Exercise")
            .navigationBarItems(
                leading: Button("Cancel") { isPresented = false },
                trailing: Button("Save") {
                    onSave()
                    isPresented = false
                }
            )
        }
    }
}
