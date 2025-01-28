import SwiftData
import SwiftUI

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
