import SwiftUI

struct EditExerciseSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var exercise: Exercise
    let onSave: (Exercise) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sets, Reps & Rest")) {
                    Stepper("Sets: \(exercise.sets)", value: $exercise.sets, in: 1...50)
                    Stepper("Reps: \(exercise.reps)", value: $exercise.reps, in: 1...50)
                    Stepper("Rest (sec): \(exercise.rest)", value: $exercise.rest, in: 0...300)
                }
            }
            .navigationTitle("Edit Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(exercise)
                        dismiss()
                    }
                }
            }
        }
    }
}
